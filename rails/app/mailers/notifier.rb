# -*- coding: utf-8 -*-
class Notifier < ActionMailer::Base
  include VehicleCDMX
  
  default from: "Verificalo <verificalo@dev.codigo.labplc.mx>"

  def confirm (user)
    @user = user
    subject = "Confirme los avisos de su auto "
    subject += user.plate
    mail(to: user.destination, subject: subject)
  end
  
  def welcome (user)
    @user = user
    @settings = Hash.new
    @user.settings.each { |s|
      @settings[s.setting] = true;
    }
    subject = "Los avisos de su auto "
    subject += user.plate
    subject += " estan confirmados"
    mail(to: user.destination, subject: subject)
  end
end
