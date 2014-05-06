class AnswersController < ApplicationController

  def home
    
  end

  def verificentros
    @verificentros_count = Verificentro.count
    @delegaciones = Delegacion.order('name')
  end

  def verificentros_query
    return unless verificentros_query_param?
    @query_value = verificentros_query_value
    if verificentros_query_type == :CP
      query = verificentros_query_value
      query += ', Ciudad de Mexico'
    else
      query = verificentros_query_value
      query += ', Ciudad de Mexico'
    end
    begin
      res = Verificentro.near(query, 60, {:order => "distance"})
    rescue
      return
    end
    @verificentros = res.slice(0, 4)
  end

  def verificentros_delegaciones
    @delegaciones = Delegacion.order('name')
  end

  def verificentros_delegacion
    url = verificentros_delegacion_param[:delegacion]
    begin
      @delegacion = Delegacion.find_by_url!(url)
      @verificentros = @delegacion.verificentros
    rescue 
      redirect_to({ action: 'verificentros' })
    end
  end

  private

  def verificentros_query_param
    params.permit(:query)
  end

  def verificentros_query_param?
    return true if verificentros_query_param[:query]
    false
  end

  def verificentros_query_type
    return :NONE unless verificentros_query_param[:query]
    query = verificentros_query_param[:query]
    query.strip!
    return :CP if query =~ /\A[0-9]{5}\z/i
    return :COLONIA
  end

  def verificentros_query_value
    return false unless verificentros_query_param?
    verificentros_query_param[:query].gsub(/[^0-9a-z ]/i, '')
  end

  def verificentros_delegacion_param
    params.permit(:delegacion)
  end

end
