module TwilioHelper

  def url_for_twilio (params)
    if ENV['VERIFICALO_TWILIO_CALLBACK_HOST']
      params[:host] = ENV['VERIFICALO_TWILIO_CALLBACK_HOST']
    end
    if ENV['VERIFICALO_TWILIO_CALLBACK_PORT']
      params[:port] = ENV['VERIFICALO_TWILIO_CALLBACK_PORT']
    end
    url_for(params)
  end
  
end
