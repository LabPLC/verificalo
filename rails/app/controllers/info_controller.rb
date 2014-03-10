class InfoController < ApplicationController
  include VehicleCDMX

  def home
    @alert = flash.alert if flash.alert
  end

  def query
    @vehicle = VehicleCDMX.new(info_params);
    if @vehicle.error
      redirect_to({ action: 'home' }, 
                  { alert: { error: @vehicle.error }})
    else
      redirect_to({ action: 'results', plate: @vehicle.plate })
    end
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
