class InfoController < ApplicationController
  include VehicleCDMX

  def home
    @alert = flash.alert if flash.alert
  end

  def results
    @vehicle = VehicleCDMX.new(info_params);
    if @vehicle.error
      redirect_to({ action: 'home' }, 
                  { alert: { error: @vehicle.error }})
    end
  end

  def verificaciones
    @vehicle = VehicleCDMX.new(info_params);
  end

  def infracciones
    @vehicle = VehicleCDMX.new(info_params);
  end

  private

  def info_params
    params.permit(:plate)    
  end
  
end
