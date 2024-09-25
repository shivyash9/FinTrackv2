class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_admin_user
    unless logged_in? && current_user.admin?
      redirect_to new_session_path, alert: 'You must be logged in and a valid admin to access this section.'
    end
  end

  def redirect_if_logged_in
    if logged_in?
      redirect_to dashboard_path, notice: 'You are already logged in.'
    end
  end

  def require_login
    unless logged_in?
      redirect_to new_session_path, alert: 'You must be logged in to access this section.'
    end
  end
end
