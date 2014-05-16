class NoticesController < ApplicationController
  include TwilioHelper

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
    
    return unless new_user
    return unless new_user_settings
    new_user_confirm
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
  
  def new_user
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
          return false
        end
      end
      render 'error'
      return false
    end
    return true
  end

  def new_user_settings
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
      return false
    rescue
      @user.destroy
      render 'error'
      return false
    end
    return @settings.each{ |s| s.save }
  end

  def new_user_confirm
    if @user.via == 'EMAIL'
      Notifier.confirm(@user).deliver
    elsif @user.via == 'PHONE'
      tw_client = Twilio::REST::Client.new(ENV['VERIFICALO_TWILIO_SSID'],
                                           ENV['VERIFICALO_TWILIO_TOKEN'])
      tw_req = { To: '+521' + @user.destination,
        :Url => url_for_tw({ controller: 'twilio', action: 'confirm', 
                             user: @user.id }),
        :Method => 'POST'
      }
      tw_client.account.calls.create(tw_defaults(tw_req))
    end
  end

end
