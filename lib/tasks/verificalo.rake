require 'vehicle_cdmx'

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
      users = User.are_active.joins(:email)
      users.where('users.plate similar to ?', weekday_plates[Date.today.wday.to_s]).each do |user|
        3.times do
          vehicle = VehicleCDMX.new({ plate: user.plate })
          if vehicle.error
            puts '! ' + user.plate + ': ' + vehicle.error
          else
            puts '- ' + user.plate
            Notifier.weekday(user, vehicle).deliver
            break
          end
        end
      end
    end

    desc "Send email notifications *before* weekends (friday)"
    task weekend: :environment do
      saturday = Date.today.tomorrow
      User.are_active.joins(:email).each do |user|
        3.times do
          vehicle = VehicleCDMX.new({ plate: user.plate })
          if vehicle.error
            puts '! ' + user.plate + ': ' + vehicle.error
          else
            puts '- ' + user.plate
            Notifier.weekend(user, vehicle, saturday).deliver
            break
          end
        end
      end
    end

  end
end
