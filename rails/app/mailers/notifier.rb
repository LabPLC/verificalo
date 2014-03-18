class Notifier < ActionMailer::Base
  include VehicleCDMX
  
  default from: "Verificalo <verificalo@dev.codigo.labplc.mx>"

  def confirm (user)
    @user = user
    mail(to: user.destination, subject: "Active su suscripcion")
  end
  
  def welcome (user)
    @user = user
    @settings = Hash.new
    @user.settings.each { |s|
      @settings[s.setting] = true;
    }
    mail(to: user.destination, subject: "Bienvenido")
  end
end
