class SessionsController < ApplicationController
  rescue_from RestClient::Unauthorized, with: :login_redirect

  def new
    redirect_to :root if user_signed_in?
  end

  def create
    user = User.authenticate(session_params)

    if user
      session[:user] = {
        username: user.username,
        token:    user.token
      }
    
      redirect_to :root, notice: t('flashes.sessions.success')
    else
      login_redirect
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: t('flashes.sessions.destroy')
  end

  private
  
  def session_params
    params.permit(
      :username, :password
    )
  end

  def login_redirect
    redirect_to login_path, alert: t('flashes.sessions.failed')
  end
end
