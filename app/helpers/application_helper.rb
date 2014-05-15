module ApplicationHelper
  def is_root?()
    if current_page?(controller: 'info', action: 'home')
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
end
