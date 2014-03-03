class InfoController < ApplicationController
  include VehicleCDMX

  def home
    @alert = flash.alert if flash.alert
  end

  def results
    @vehicle = VehicleCDMX.new(params[:plate]);
    if @vehicle.error
      redirect_to({ action: 'home' }, 
                  { alert: { error: @vehicle.error, plate: params[:plate] }})
    end
  end

  def verificaciones
    @vehicle = VehicleCDMX.new(params[:plate]);
  end
end
