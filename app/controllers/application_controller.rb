class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_action :record_activity

  def favicon
    redirect_to '/assets/favicon.ico'
  end

  # Meant to be used as before_action in any controllers that are not publicly accessible
  def require_authentication
    redirect_to login_path, alert: t('flashes.sessions.expired') unless user_signed_in?
  end

  def reset_token
    user_token = current_user['token'] if user_signed_in?
    @client = TrackerApi::Client.new(token: user_token)
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

  def record_activity
    activity_param = {
        activity_type: "#{params[:controller]}\##{params[:action]}",
        user_id: current_user.nil? ? nil : current_user[:id],
    }

    if params[:action].eql? 'project'
      activity_param[:project_id] = params[:id].to_i
    end

    if @resource
      activity_param.update({
        story_id: @resource.key?(:story_id) ?  @resource[:story_id] : @resource[:id],
        activity_data: @resource.to_json
      })
    end
    Activity.create activity_param
  end

  # rescue_from !client do |exception|
  #   rescue_steps t('flashes.sessions.token')
  # end

  rescue_from RestClient::Unauthorized do |exception|
    rescue_steps t('flashes.sessions.unauthorized')
  end

  rescue_from TrackerApi::Errors::ClientError do
    rescue_steps t('flashes.sessions.unauthorized')
  end

end
