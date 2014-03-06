class NoticesController < ApplicationController
  include VehicleCDMX

  def home
  end

  def email
    render layout: false
  end

  def sms
    render layout: false
  end

  def phone
    render layout: false
  end

  def results
    @user = User.new(user_params)
    if !@user.save
      @error = 'USER_PARAMS_ERROR'
      return
    end
    begin      
      @settings = settings_params.collect{ |x|
        setting = Setting.new(x)
        raise if setting.invalid?
        setting
      }
    rescue ActionController::ParameterMissing
      @error = 'SETTINGS_COUNT_ERROR'
      @user.destroy
    rescue
      @error = 'SETTINGS_PARAMS_ERROR'
      @user.destroy
    else
      @settings.each{ |s| s.save }
      Notifier.confirm(@user).deliver
    end
  end
  
  def confirm
    begin
      @user = User.find(params[:user])
    rescue
      @error = 'USER_NOT_FOUND'
    else
      @user.confirmed_at = Time.now
      @user.save
      Notifier.welcome(@user).deliver
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:plate, :via, :destination)
  end
  
  def settings_params
    params.require(:settings).collect{ |k, v| { user_id: @user.id, setting: k } }
  end

end
