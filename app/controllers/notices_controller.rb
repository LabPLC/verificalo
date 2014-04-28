class NoticesController < ApplicationController
  include VehicleCDMX

  def home
    @params = params
    unless request.post?
      return
    end
    @errors = Hash.new
    @user = User.new(user_params)
    @debug = @user.errors
    if !@user.save
      if @user.errors[:plate].count > 0
        @errors[:INVALID_PLATE] = true
      end
      if @user.errors[:destination].count > 0
        @errors[:INVALID_EMAIL] = true
      end
      unless @errors[:INVALID_PLATE] || @errors[:INVALID_EMAIL]
        render 'error'
        return
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
      @user.destroy
      @errors[:INVALID_SETTINGS_COUNT] = true
    rescue
      @user.destroy
      render 'error'
      return
    else
      @settings.each{ |s| s.save }
      Notifier.confirm(@user).deliver
      render 'results'
    end
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
