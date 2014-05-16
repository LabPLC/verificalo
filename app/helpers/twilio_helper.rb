module TwilioHelper

  def url_for_tw (params)
    if ENV['VERIFICALO_TWILIO_CALLBACK_HOST']
      params[:host] = ENV['VERIFICALO_TWILIO_CALLBACK_HOST']
    end
    if ENV['VERIFICALO_TWILIO_CALLBACK_PORT']
      params[:port] = ENV['VERIFICALO_TWILIO_CALLBACK_PORT']
    end
    url_for(params)
  end

  def tw_defaults (params)
    params[:From] = ENV['VERIFICALO_TWILIO_FROM']
    params[:FallbackUrl] = url_for_tw({ controller: 'twilio', action: 'error' })
    params[:FallbackMethod] = 'GET'
    params[:Record] = 'false'
    params[:IfMachine] = 'Hangup'
    params[:Timeout] = 30
    params
  end

end
