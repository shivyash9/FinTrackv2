class DashboardController < ApplicationController
  before_action :require_login

  def show
  end

  private

  def require_login
    unless session[:user_id]
      redirect_to new_session_path, alert: 'You must be logged in to access this page.'
    end
  end
end
