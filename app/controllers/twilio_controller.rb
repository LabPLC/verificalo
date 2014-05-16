# -*- coding: utf-8 -*-
class TwilioController < ApplicationController
  include Webhook
  include TwilioHelper

  after_filter :set_header
  skip_before_action :verify_authenticity_token

  def confirm
    begin
      @user = User.find(user_id_param)
    rescue
      error
      return
    end    

    msg = 'Si desea recibir los avisos de su auto con placa;'
    msg += @user.plate.downcase.split(//).join(';')
    msg += ';Presione 1 o de lo contrario cuelgue'

    res = Twilio::TwiML::Response.new do |r|
      2.times do
        r.Gather(numDigits: '1', timeout: '10', method: 'POST',
                 action: url_for_tw({ action: 'accept',
                                      user: @user.id })) do |g|
          g.Say(msg, voice: 'alice', language: 'es-MX')
        end
      end
    end
    
    render_twiml res
  end
  
  def accept
    begin
      @user = User.find(user_id_param)
      @user.confirmed_at = Time.now
      @user.save
    rescue
      error
      return
    end
    
    msg = 'Su suscripción esta confirmada, recibira avisos sobre; '
    if @user.settings.find_by_setting('VERIFICACION')
      msg += 'verificación; '
    end
    if @user.settings.find_by_setting('ADEUDOS')
      msg += 'pagos de tenencias e infracciones; '
    end
    if @user.settings.find_by_setting('NO_CIRCULA_WEEKDAY')
      msg += 'hoy no circula de lunes a viernes; '
    end
    if @user.settings.find_by_setting('NO_CIRCULA_WEEKEND')
      msg += 'hoy no circula sabatino; '
    end
    msg += ';Gracias por usar Verifícalo'

    res = Twilio::TwiML::Response.new do |r|
      r.Say(msg, voice: 'alice', language: 'es-MX')
    end
    
    render_twiml res
  end
  
  def error
    msg = 'Ocurrio un error, vuelva a intentarlo'
    res = Twilio::TwiML::Response.new do |r|
      r.Say(msg, voice: 'alice', language: 'es-MX')
    end

    render_twiml res
  end

  private

  def user_id_param
    params.require(:user)
    params[:user]
  end

end
