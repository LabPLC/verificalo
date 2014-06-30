module ApplicationHelper
  def is_root?()
    if params[:controller] == 'info' && params[:action] == 'home'
      true
    else
      false
    end
  end

  def is_about?()
    if params[:controller] == 'static_pages' && params[:action] == 'about'
      true
    else
      false
    end
  end

  def is_active?(controller)
    if params[:controller] == controller
      'active'
    else
      ''
    end
  end

  def icon (type)
    if type == :ok
      '<span class="glyphicon glyphicon-ok-sign green icon"></span>'.html_safe
    elsif type == :warning
      '<span class="glyphicon glyphicon-info-sign orange icon"></span>'.html_safe
    elsif type == :error
      '<span class="glyphicon glyphicon-exclamation-sign red icon"></span>'.html_safe
    elsif type == :question
      '<span class="glyphicon glyphicon-question-sign blue icon"></span>'.html_safe
    elsif type == :phone
      '<span class="glyphicon glyphicon-earphone bullet"></span>'.html_safe
    elsif type == :mail
      '<span class="glyphicon glyphicon-envelope bullet"></span>'.html_safe
    elsif type == :address
      '<span class="glyphicon glyphicon-home bullet"></span>'.html_safe
    elsif type == :web
      '<span class="glyphicon glyphicon-globe bullet"></span>'.html_safe
    elsif type == :wrench
      '<span class="glyphicon glyphicon-wrench bullet"></span>'.html_safe
    end
  end
end
