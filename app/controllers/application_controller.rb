class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :ensure_signed_in!

  def signin!(user)
    session[:session_token] = user.reset_session_token!
  end

  def signout!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def ensure_signed_in!
    redirect_to new_session_url unless current_user
  end

end
