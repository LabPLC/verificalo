class InfoController < ApplicationController
  include VehicleCDMX

  def home
    if flash[:error]
      @error = flash[:error]
      return
    end
    unless plate_param?
      return
    end
    @vehicle = VehicleCDMX.new(plate_param)
    if @vehicle.error
      @error = @vehicle.error
    else
      redirect_to({ action: 'results', plate: @vehicle.plate })
    end
  end
  
  def results
    @params = params
    @session = session.to_hash
    @vehicle = VehicleCDMX.new(info_params)
    if @vehicle.error
      redirect_to({ action: 'home' }, { flash: { error: @vehicle.error } })
      return
    end
    if !session.has_key?(:plate) || session[:plate] != @vehicle.plate
      session[:plate] = @vehicle.plate
      session.delete(:vin)
      session.delete(:registration_date)
    end
    if @vehicle.user_vin_valid?
      session[:vin] = @vehicle.user_vin
    end
    if @vehicle.verificaciones_vins?
      if session.has_key?(:vin)
        @vehicle.user_vin = session[:vin]
      else
        render 'vin'
        return
      end
    end
    if @vehicle.registration_date_valid?
      session[:registration_date] = @vehicle.registration_date.to_s
    end
    if @vehicle.verificacion_never? && !@vehicle.registration_date_valid?
      if session.has_key?(:registration_date)
        @vehicle.registration_date = session[:registration_date]
      else
        render 'registration'
        return
      end
    end
  end
  
  def verificaciones
    @params = params
    @session = session.to_hash
    @vehicle = VehicleCDMX.new(plate_param)
    if @vehicle.error
      redirect_to({ action: 'home' }, { flash: { error: @vehicle.error } })
      return
    end
    if @vehicle.verificaciones_vins?
      if session.has_key?(:vin) && session[:plate] == @vehicle.plate
        @vehicle.user_vin = session[:vin]
      else
        redirect_to({ action: 'results', plate: @vehicle.plate })
        return
      end
    end
  end
  
  def infracciones
    @vehicle = VehicleCDMX.new(plate_param)
  end
  
  private
    
  def plate_param
    params.permit(:plate)
  end

  def plate_param?
    return true if plate_param[:plate]
    false
  end

  def info_params
    params.permit(:plate, :vin, registration: [:day, :month, :year])
  end
end
