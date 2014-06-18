module NoticesHelper
  def type_selected (name, value)
    if params[name] && params[name] == value
      'checked="true"'
    else
      ''
    end
  end

  def setting_checked (setting, default)
    checkbox_checked(:user, setting, default)
  end

  def schedule_checked (schedule, default)
    checkbox_checked(:phone, schedule, default)
  end

  def phone_selected (extra, value, default)
    radio_checked(:phone, extra, value, default)
  end

  private

  def checkbox_checked (array, checkbox, default)
    if (request.get? && default == true) || 
        (params[array] && params[array][checkbox])
      'checked="true"'
    else
      ''
    end
  end

  def radio_checked (array, radio, value, default)
    if (request.get? && default == true) || 
        (params[array] && params[array][radio] == value)
      'checked="true"'
    else
      ''
    end
  end
end
