class AnswersController < ApplicationController

  def home
  end

  def verificentros
    @verificentros_count = Verificentro.count
    @delegaciones = Delegacion.find(:all, :order => "name")
  end

  def verificentros_query
  end

  def verificentros_delegaciones
    @delegaciones = Delegacion.find(:all, :order => "name")
  end
  
  def verificentros_delegacion
    url = verificentros_delegacion_params[:delegacion]
    @delegacion = Delegacion.find_by_url(url)
    raise unless @delegacion
    @verificentros = @delegacion.verificentros
  end
  
  private
  
  def verificentros_delegacion_params
    params.permit(:delegacion)
  end

end
