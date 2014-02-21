class NoticesController < ApplicationController
  def home
  end

  def email
    render layout: false
  end

  def sms
    render layout: false
  end

  def phone
    render layout: false
  end

  def success
  end
end
