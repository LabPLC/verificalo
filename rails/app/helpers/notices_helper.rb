module NoticesHelper
  def setting_checked (setting, default)
    if (request.get? && default == true) || (params[:settings] && params[:settings][setting])
      'checked="true"'
    else
      ''
    end
  end
end
