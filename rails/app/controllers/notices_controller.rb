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

  def results
    @user = User.new(user_params)
    @debug = @user.errors
    if !@user.save
      if @user.errors[:plate].count > 0
        @error = 'INVALID_PLATE'
      elsif @user.errors[:destination].count > 0
        @error = 'INVALID_EMAIL'
      else
        @error = 'USER_SAVE_ERROR'
      end
      return
    end
    begin      
      @settings = settings_params.collect{ |x|
        setting = Setting.new(x)
        raise if setting.invalid?
        setting
      }
    rescue ActionController::ParameterMissing
      @error = 'INVALID_SETTINGS_COUNT'
      @user.destroy
    rescue
      @error = 'INVALID_SETTING'
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
