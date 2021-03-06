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
                                      uuid: @user.id })) do |g|
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
      @user.destroy_outdated
    rescue
      error
      return
    end
    
    msg = 'Su suscripción esta confirmada, recibira avisos sobre; '
    msg += 'verificación; ' if @user.verificacion
    msg += 'pagos de tenencias e infracciones; ' if @user.adeudos
    msg += 'hoy no circula de lunes a viernes; ' if @user.no_circula_weekday
    msg += 'hoy no circula sabatino; ' if @user.no_circula_weekend
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
    params.require(:uuid)
    params[:uuid]
  end

end
