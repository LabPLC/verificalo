require 'vehicle_cdmx'
require 'csv'
require 'i18n'
require 'database_cleaner'

logger = Logger.new(STDOUT)
logger.level = Logger::INFO
ActiveRecord::Base.logger = logger
ActionMailer::Base.logger = logger
ActionController::Base.logger = logger

namespace :verificalo do
  
  weekday_plates = { 
    #'0' => '[0-9]{3}[A-Z]{3}',
    '0' => '[0-9]{2}(5|6)[A-Z]{3}',
    '1' => '[0-9]{2}(7|8)[A-Z]{3}',
    '2' => '[0-9]{2}(3|4)[A-Z]{3}',
    '3' => '[0-9]{2}(1|2)[A-Z]{3}',
    '4' => '[0-9]{2}(9|0)[A-Z]{3}'
  }

  namespace :emails do
    
    desc "Send email notifications *before* weekdays (sunday to thursday)"
    task weekday: :environment do
      logger.warn '-' * 50
      users = User.are_active.joins(:email)
      users.where('users.plate similar to ?', weekday_plates[Date.today.wday.to_s]).each do |user|
        3.times do
          vehicle = VehicleCDMX.new({ plate: user.plate })
          if vehicle.error
            logger.error user.plate + ' error: ' + vehicle.error
          else
            logger.warn user.plate
            Notifier.weekday(user, vehicle).deliver
            break
          end
        end
      end
    end

    desc "Send email notifications *before* weekends (friday)"
    task weekend: :environment do
      logger.warn '-' * 50
      saturday = Date.today.tomorrow
      User.are_active.joins(:email).each do |user|
        3.times do
          vehicle = VehicleCDMX.new({ plate: user.plate })
          if vehicle.error
            logger.error user.plate + ' error: ' + vehicle.error
          else
            logger.warn user.plate
            Notifier.weekend(user, vehicle, saturday).deliver
            break
          end
        end
      end
    end

  end

  namespace :db do

    desc "Load answers from db/seeds/answers.rb"
    task answers: :environment do
      raitings = { }
      Answer.find_each do |a|
        raitings[a.url] = { views: a.views, positive: a.positive, negative: a.negative }
      end
      DatabaseCleaner.clean_with :truncation, { only: [ 'categories',
                                                        'contacts',
                                                        'answers' ] }
      load File.join(Rails.root, 'db/seeds/answers.rb')
      raitings.each do |url, r|
        a = Answer.find_by_url(url)
        next unless a
        a.update(views: r[:views], positive: r[:positive], negative: r[:negative])
      end
    end

    desc "Load verificentros from db/seeds/verificentros.csv"
    task verificentros: :environment do
      DatabaseCleaner.clean_with :truncation, { only: [ 'verificentros' ] }
      CSV.foreach(File.join(Rails.root, 'db/seeds/verificentros.csv'), :headers => true) do |r|
        next unless r['DIRECCION']
        d = Delegacion.find_by(url: r['DELEGACION'].downcase.gsub(/\s+/, '-'))
        unless d
          d = Delegacion.where("unaccent(lower(name)) = ?", r['DELEGACION'].downcase).first
        end
        unless d
          puts 'delegacion not found: ' + r['DELEGACION']
          next
        end
        Verificentro.create(number: r['VERIFICENTRO'], 
                            name: r['RAZON SOCIAL'], 
                            address: r['DIRECCION'], 
                            delegacion_id: d.id, 
                            phone: r['TELEFONOS'],
                            lat: r['LATITUD'],
                            lon: r['LONGITUD'])
      end
    end
  end
end
