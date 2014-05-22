# -*- coding: utf-8 -*-
class Notifier < ActionMailer::Base
  include VehicleCDMX
  
  default from: ENV['VERIFICALO_SMTP_FROM'] || 'default@example.com'

  def confirm (user)
    @user = user
    subject = "Confirme los avisos de su auto "
    subject += @user.plate
    mail(to: @user.email.address, subject: subject)
  end
  
  def welcome (user)
    @user = user
    subject = "Los avisos de su auto "
    subject += @user.plate
    subject += " estan confirmados"
    mail(to: @user.email.address, subject: subject)
  end
end
