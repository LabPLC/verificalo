# -*- coding: utf-8 -*-
class NoticesController < ApplicationController
  include VehicleCDMX

  def home
    
  end
  
  def email
    render layout: false
  end
  
  def phone
    render layout: false
  end

  def twitter
    render layout: false
  end

  def new
    @params = params
    @errors = Hash.new

    begin
      @user = User.new(user_params)      
      @user.save!
      @debug = @user.errors
    rescue
      if @user && @user.errors
        if @user.errors[:plate].count > 0
          @errors[:INVALID_PLATE] = true
        end
        if @user.errors[:destination].count > 0
          @errors[:INVALID_DESTINATION] = true
        end
        if @errors[:INVALID_DESTINATION] || @errors[:INVALID_PLATE]
          render 'home'
          return
        end
      end
      render 'error'
      return
    end
    
    begin
      @settings = settings_params.collect{ |x|
        setting = Setting.new(x)
        raise if setting.invalid?
        setting
      }
    rescue ActionController::ParameterMissing
      @user.destroy
      @errors[:INVALID_SETTINGS_COUNT] = true
      render 'home'
      return
    rescue
      @user.destroy
      render 'error'
      return
    else
      @settings.each{ |s| s.save }
    end
    
    if @user.via == 'EMAIL'
      Notifier.confirm(@user).deliver
    elsif @user.via == 'PHONE'
      tw_client = Twilio::REST::Client.new(ENV['VERIFICALO_TWILIO_SSID'],
                                           ENV['VERIFICALO_TWILIO_TOKEN'])
      tw_req = { to: '+521' + @user.destination,
        from: '+17542108617',
        url: url_for({ action: 'twilio_confirm', 
                       #host: '4ba91c34.ngrok.com', port: '80',
                       user: @user.id }),
        method: 'GET',
        record: 'false' }
      tw_client.account.calls.create(tw_req)
    end
  end

  def confirm
    begin
      @user = User.find(user_id_param)
    rescue
      @error = 'USER_NOT_FOUND'
      return
    end
    @user.confirmed_at = Time.now
    @user.save
    Notifier.welcome(@user).deliver
  end

  def twilio_confirm
    begin
      @user = User.find(user_id_param)
    rescue
      render 'error'
      return
    end

    response.headers["Content-Type"] = "text/xml"
    msg = 'Si desea recibir los avisos de su auto con placa '
    msg += @user.plate.split(//).join(';')
    msg += ' presione 1 o de lo contrario cuelgue'
    response = Twilio::TwiML::Response.new do |r|
      r.Pause(length: 2)
      2.times do
        r.Gather(numDigits: '1', timeout: '10', method: 'GET',
                 action: url_for({ action: 'twilio_accept',
                                   #host: '4ba91c34.ngrok.com', port: '80',
                                   user: @user.id })) do |g|
          g.Say(msg, voice: 'alice', language: 'es-MX')
        end
      end
    end
    render text: response.text
  end
  
  def twilio_accept
    begin
      @user = User.find(user_id_param)
      @user.confirmed_at = Time.now
      @user.save
    rescue
      render 'error'
      return
    end

    response.headers["Content-Type"] = "text/xml"
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
    response = Twilio::TwiML::Response.new do |r|
      r.Say(msg, voice: 'alice', language: 'es-MX')
    end
    render text: response.text
  end  
  
  private

  def user_params
    params.require(:user).permit(:plate, :via, :destination)
  end

  def settings_params
    params.require(:settings).collect{ |k, v| { user_id: @user.id, setting: k } }
  end
  
  def user_id_param
    params.require(:user)
    params[:user]
  end
  
end
