class AnswersController < ApplicationController

  def home
    @categories = Category.order("priority ASC")
    return unless search_param[:q].present?
    begin
      @results = Answer.search(search_param[:q], suggest: true)
      session[:q] = search_param[:q]
    rescue
      return
    end
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
      answer_view(@answer.id)
    rescue
     redirect_to({ action: 'home' })
    end
  end
  
  def verificentros
    @answer = Answer.find(3)
    answer_view(@answer.id)
    @verificentros_count = Verificentro.not_suspended.count
    @delegaciones = Delegacion.order('name')
  end

  def verificentros_search
    @answer = Answer.find(3)
    if verificentros_search_param[:verificentros_query].present?
      query = verificentros_search_param[:verificentros_query]
      query += ', Ciudad de Mexico'
    else
      @verificentros = [ ]
      return
    end
    begin
      res = Verificentro.not_suspended.near(query, 60, {:order => "distance"})
    rescue
      return
    end
    @verificentros = res.slice(0, 4)
  end

  def verificentros_delegacion
    @answer = Answer.find(3)
    url = verificentros_delegacion_param[:delegacion_url]
    begin
      @delegacion = Delegacion.find_by_url!(url)
      @verificentros = @delegacion.verificentros.not_suspended
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
    params.permit(:q)
  end

  def verificentros_search_param
    params.permit(:verificentros_query)
  end
  
  def verificentros_delegacion_param
    params.permit(:delegacion_url)
  end

  def answer_view (id)
    unless session[:views]
      session[:views] = { }
    end
    unless session[:views][id]
      Answer.increment_counter("views", id)
      session[:views][id] = 1
    end
  end

end
