class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def favicon
    redirect_to '/assets/favicon.ico'
  end

  # Meant to be used as before_action in any controllers that are not publicly accessible
  def require_authentication
    redirect_to login_path, alert: t('flashes.sessions.expired') unless user_signed_in?
  end

  def reset_token
    PivotalTracker::Client.token = current_user['token'] if user_signed_in?
  end

  helper_method :user_signed_in?, :current_user

  def current_user
    @current_user ||= session[:user]
  end

  def user_signed_in?
    !!session[:user]
  end

  def rescue_steps(message)
    reset_session
    redirect_to login_path, alert: message
  end

  rescue_from PivotalTracker::Client::NoToken do |exception|
    rescue_steps t('flashes.sessions.token')
  end

  rescue_from RestClient::Unauthorized do |exception|
    rescue_steps t('flashes.sessions.unauthorized')
  end
end
