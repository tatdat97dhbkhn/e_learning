class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "log_in"
    redirect_to login_url
  end

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
