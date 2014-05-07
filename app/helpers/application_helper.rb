module ApplicationHelper
  def is_active?(controller)
    if params[:controller] == controller
      'active'
    else
      ''
    end
  end
end
