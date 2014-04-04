class AnswersController < ApplicationController

  def home
  end

  def verificentros
    @verificentros_count = Verificentro.count
    @delegaciones = Delegacion.find(:all, :order => "name")
  end

end
