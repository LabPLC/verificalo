# -*- coding: utf-8 -*-
require 'vehicle_cdmx'

class Notifier < ActionMailer::Base
  
  default from: ENV['VERIFICALO_SMTP_FROM'] || 'default@example.com'

  def confirm (user)
    subject = 'Confirma los recordatorios de tu auto '
    subject += user.plate
    @user = user
    mail(to: user.email.address, subject: subject)
  end  
  
  def weekday (user, vehicle) 
    return unless (user.verificacion && (vehicle.verificacion_expired? ||
                                         vehicle.verificacion_period?)) ||
      (user.no_circula_weekday && (vehicle.no_circula_dos? ||
                                   vehicle.no_circula_expired?)) ||
      (user.adeudos && vehicle.adeudos?)
    @user = user
    @vehicle = vehicle
    subject = 'Recordatorios de tu auto ' + user.plate
    mail(to: user.email.address, subject: subject)
  end

end
