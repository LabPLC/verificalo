class Notifier < ActionMailer::Base
  include VehicleCDMX
  
  default from: "Verificalo <verificalo@dev.codigo.labplc.mx>"

  def confirm(user)
    @user = user
    mail(to: user.destination, subject: "Active su suscripcion")
  end
  
  def welcome(user)
    @user = user
    @vehicle = VehicleCDMX.new(@user.plate)
    mail(to: user.destination, subject: "Bienvenido")
  end
end
