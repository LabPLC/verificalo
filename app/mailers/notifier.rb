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
    return unless 
      # verificacion vencida
      ((user.no_circula_weekday || user.verificacion) && vehicle.verificacion_expired?) || 
      # nunca ha verificado
      ((user.no_circula_weekday || user.verificacion) && !vehicle.verificaciones_approved?) ||
      # en periodo para verficar
      (user.verificacion && vehicle.verificacion_period?) ||
      # no circula
      (user.no_circula_weekday && (vehicle.no_circula_uno? || vehicle.no_circula_dos?)) ||
      # tiene adeudos
      (user.adeudos && vehicle.adeudos?)
    @user = user
    @vehicle = vehicle
    subject = 'Recordatorios de tu auto ' + user.plate
    mail(to: user.email.address, subject: subject)
  end

  def weekend (user, vehicle)
    saturday = Date.today.tomorrow
    return unless 
      # nunca ha verificado
      (user.no_circula_weekend && !vehicle.verificaciones_approved?) ||
      # no circula holograma uno
      (user.no_circula_weekend && vehicle.no_circula_uno? && vehicle.no_circula_weekend?(saturday)) ||
      # no circula holograma dos
      (user.no_circula_weekend && vehicle.no_circula_dos?)
    @user = user
    @vehicle = vehicle
    @saturday = saturday
    subject = 'Recordatorios de tu auto ' + user.plate
    mail(to: user.email.address, subject: subject)
  end

end
