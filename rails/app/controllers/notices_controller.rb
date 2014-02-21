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
    @params = params
    @vehicle = VehicleCDMX.new(params[:plate]);
    if @vehicle.error
      redirect_to({ action: 'home' }, 
                  { alert: { error: @vehicle.error, plate: params[:plate] }})
    end
  end
end
