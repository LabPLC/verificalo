require 'vehicle_cdmx'

class InfoController < ApplicationController

  def home
    if flash[:error]
      @error = flash[:error]
      return
    end
    return unless plate_param?
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
    if !@vehicle.verificaciones_approved? && !@vehicle.registration_date_valid?
      if session.has_key?(:registration_date)
        @vehicle.registration_date = session[:registration_date]
      else
        render 'registration'
        return
      end
    end
  end
  
  def verificaciones
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
    if !@vehicle.verificacion_current? && !@vehicle.registration_date_valid?
      if session.has_key?(:registration_date)
        @vehicle.registration_date = session[:registration_date]
      else
        redirect_to({ action: 'results', plate: @vehicle.plate })        
        return
      end
    end
  end
  
  def infracciones
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
    if !@vehicle.verificacion_current? && !@vehicle.registration_date_valid?
      if session.has_key?(:registration_date)
        @vehicle.registration_date = session[:registration_date]
      else
        redirect_to({ action: 'results', plate: @vehicle.plate })        
        return
      end
    end
  end

  def reset
    @params = params
    @session = session.to_hash
    redirect_to({ action: 'home' }) unless plate_param? || reset_param?
    if session.has_key?(:vin) && reset_vin?
      session.delete(:vin)
    elsif params[:item] == 'alta' && reset_registration_date?
      session.delete(:registration_date)
    end
    redirect_to({ action: 'results', plate: plate_param[:plate] })
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

  def reset_params
    params.permit(:item)
  end

  def reset_vin?
    return true if reset_params[:item] == 'vin'
    false
  end

  def reset_registration_date?
    return true if reset_params[:item] == 'alta'
    false
  end
end
