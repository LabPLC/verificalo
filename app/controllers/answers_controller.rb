class AnswersController < ApplicationController

  def home
    @categories = Category.order("priority ASC")
  end

  def category
    category_url = category_param[:category_url]
    begin
      @category = Category.find_by_url!(category_url)
      @answers = @category.answers.order("title ASC")
    rescue
      redirect_to({ action: 'home' })
    end
  end

  def answer
    category_url = category_param[:category_url]
    answer_url = answer_param[:answer_url]
    begin
      @answer = Answer.find_by_url!(answer_url)
      raise unless category_url == @answer.category.url
    rescue
     redirect_to({ action: 'home' })
    end
  end
  
  def search
    @categories = Category.order("priority ASC")
    begin
      @answers = Answer.search(search_param[:answers_query], suggest: true)
    rescue
      return
    end
  end

  def verificentros
    @answer = Answer.find(1)
    @verificentros_count = Verificentro.count
    @delegaciones = Delegacion.order('name')
  end

  def verificentros_query
    @answer = Answer.find(1)
    return unless verificentros_query_param?
    @query_value = verificentros_query_param[:verificentros_query]
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

  def verificentros_delegacion
    @answer = Answer.find(1)
    url = verificentros_delegacion_param[:delegacion]
    begin
      @delegacion = Delegacion.find_by_url!(url)
      @verificentros = @delegacion.verificentros
    rescue 
      redirect_to({ action: 'verificentros' })
    end
  end

  private

  def category_param
    params.permit(:category_url)
  end

  def answer_param
    params.permit(:answer_url)
  end
  
  def search_param
    params.permit(:answers_query)
  end

  # REVISAR

  def verificentros_query_param
    params.permit(:query)
  end
  
  def verificentros_query_param?
    return true if verificentros_query_param[:query]
    false
  end

  def verificentros_query_value
    return false unless verificentros_query_param?
    verificentros_query_param[:query].gsub(/[^0-9a-z ]/i, '')
  end

  def verificentros_query_type
    return :NONE unless verificentros_query_param[:query]
    query = verificentros_query_param[:query]
    query.strip!
    return :CP if query =~ /\A[0-9]{5}\z/i
    return :COLONIA
  end

  def verificentros_delegacion_param
    params.permit(:delegacion)
  end

end
