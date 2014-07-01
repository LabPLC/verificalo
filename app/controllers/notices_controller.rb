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

  def new
    @params = params
    @errors = Hash.new

    return unless new_user

    if type_param == 'EMAIL'
      return unless new_email
    elsif type_param == 'PHONE'
      return unless new_phone
    end

    new_user_confirm
  end

  def user
    begin
      @user = User.find(user_id_param)
    rescue
      @error = 'USER_NOT_FOUND'
      return
    end
    if @user.declined_at
      @error = 'USER_DECLINED'
      render 'user'
      return
    end
    unless @user.confirmed_at
      @user.confirmed_at = Time.now
      @user.save
      @user.destroy_outdated
      render 'confirm'
    else
      render 'modify'
    end
  end

  def modify
    @errors = Hash.new
    @params = params

    begin
      @user = User.find(user_id_param)
    rescue
      @error = 'USER_NOT_FOUND'
      render 'user'
      return
    end

    if @user.declined_at
      @error = 'USER_DECLINED'
      render 'user'
      return
    end

    @user.attributes = user_params
    unless params[:user][:verificacion].present?
      @user.verificacion = false 
    end
    unless params[:user][:adeudos].present?
      @user.adeudos = false
    end
    unless params[:user][:no_circula_weekday].present?
      @user.no_circula_weekday = false
    end
    unless params[:user][:no_circula_weekend].present?
      @user.no_circula_weekend = false
    end

    if @user.save
      @user.destroy_outdated
    else
      if @user.errors[:plate].count > 0
        @errors[:INVALID_USER_PLATE] = true
      end
      if @user.errors[:notices].count > 0
        @errors[:MISSING_USER_NOTICES] = true
      end
    end
  end

  def cancel 
    begin
      @user = User.find(user_id_param)
    rescue
      @error = 'USER_NOT_FOUND'
      render 'user'
      return
    end
    if @user.declined_at
      @error = 'USER_DECLINED'
      render 'user'
      return
    end
    if request.post?
      @user.declined_at = Time.now
      @user.save      
    end
  end

  private

  def type_param
    params.require(:type)
  end

  def user_params
    params.require(:user).permit(:plate, :adeudos, :verificacion, 
                                 :no_circula_weekday, :no_circula_weekend)
  end

  def email_params
    params.require(:email).permit(:address)
  end

  def phone_params
    params.require(:phone).permit(:number, :cellphone, 
                                  :morning, :afternoon, :night)
  end

  def user_id_param
    params.require(:uuid)
    params[:uuid]
  end

  def new_user
    begin
      raise unless type_param =~ /\A(EMAIL|PHONE)\z/
      @user = User.new(user_params)
    rescue
      render 'error'
      return false
    end

    unless @user.save
      if @user.errors[:plate].count > 0
        @errors[:INVALID_USER_PLATE] = true
      end
      if @user.errors[:notices].count > 0
        @errors[:MISSING_USER_NOTICES] = true
      end
      if @errors.length > 0 
        render 'home'
      else
        render 'error'
      end
      return false
    end

    true
  end

  def new_email
    begin
      @email = @user.build_email(email_params)
    rescue
      @user.destroy
      render 'error'
      return false
    end

    unless @email.save
      @user.destroy
      if @email.errors[:address].count > 0
        @errors[:INVALID_EMAIL_ADDRESS] = true
        render 'home'
      else
        render 'error'
      end
      return false
    end

    true
  end

  def new_phone
    begin
      @phone = @user.build_phone(phone_params)
    rescue
      @user.destroy
      render 'error'
      return false
    end

    unless @phone.save
      @user.destroy
      if @phone.errors[:number].count > 0
        @errors[:INVALID_PHONE_NUMBER] = true
      end
      if @phone.errors[:schedule].count > 0
        @errors[:MISSING_PHONE_SCHEDULE] = true
      end
      if @phone.errors[:cellphone].count > 0
        @errors[:MISSING_PHONE_CELLPHONE] = true
      end
      if @errors.length > 0 
        render 'home'
      else
        render 'error'
      end
      return false
    end
    
    true
  end

  def new_user_confirm
    if type_param == 'EMAIL'
      Notifier.confirm(@user).deliver
    elsif type_param == 'PHONE'
      @tw_req = { To: @user.phone.number.dup,
        Url: url_for_tw({ controller: 'twilio', action: 'confirm',
                          uuid: @user.id }),
        Method: 'POST'
      }
      if @user.phone.cellphone
        @tw_req[:To].prepend('+521')
      else
        @tw_req[:To].prepend('+52')
      end
      unless Rails.env.test?
        tw_client = Twilio::REST::Client.new(ENV['VERIFICALO_TWILIO_SSID'],
                                             ENV['VERIFICALO_TWILIO_TOKEN'])
        tw_client.account.calls.create(tw_defaults(@tw_req))
      end
    end
    true
  end

end
