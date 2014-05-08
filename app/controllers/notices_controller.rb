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
      @user.destination.insert(0, prefix_param) if prefix_param?
    rescue
      redirect_to({ action: 'home' })
      return
    end
    @debug = @user.errors
    if !@user.save
      if @user.errors[:plate].count > 0
        @errors[:INVALID_PLATE] = true
      end
      if @user.errors[:destination].count > 0
        @errors[:INVALID_DESTINATION] = true
      end
      unless @errors[:INVALID_PLATE] || @errors[:INVALID_DESTINATION]
        render 'error'
        return
      end
      render 'home'
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
    end
    @settings.each{ |s| s.save }
    Notifier.confirm(@user).deliver
    render 'results'
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

  def prefix_param?
    return false unless params.has_key?(:extra)
    return true if params[:extra].has_key?(:prefix)
    false
  end
  
  def prefix_param
    return flase unless prefix_param?
    params[:extra][:prefix]
  end

  def settings_params
    params.require(:settings).collect{ |k, v| { user_id: @user.id, setting: k } }
  end

end
