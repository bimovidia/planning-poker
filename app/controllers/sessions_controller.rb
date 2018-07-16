class SessionsController < ApplicationController

  def new
    redirect_to :root if user_signed_in?
  end

  def create
    user = User.authenticate(session_params)

    if user
      session[:user] = {
        username: user.username,
        token:    user.token,
      }
    
      redirect_to :root, notice: t('flashes.sessions.success')
    else
      redirect_to :login, alert: t('flashes.sessions.failed')
    end
  end

  def destroy
    reset_session
    redirect_to :login, notice: t('flashes.sessions.destroy')
  end

  private
  
  def session_params
    params.permit(
      :username, :password
    )
  end
end