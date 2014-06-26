# -*- coding: utf-8 -*-
require 'vehicle_cdmx'

class Notifier < ActionMailer::Base
  
  default from: ENV['VERIFICALO_SMTP_FROM'] || 'default@example.com'

  def confirm (user)
    @user = user
    subject = "Confirma los recordatorios de tu auto "
    subject += @user.plate
    mail(to: @user.email.address, subject: subject)
  end  
end
