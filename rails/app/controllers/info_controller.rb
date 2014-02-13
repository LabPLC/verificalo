class InfoController < ApplicationController
  include VehicleCDMX

  def home
    @vehicle = VehicleCDMX.new('436per');
  end

  def results
  end
end
