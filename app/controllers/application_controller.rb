class ApplicationController < ActionController::Base
  helper_method :current_tenant, :current_user, :logged_in?
  before_action :set_current_tenant
  before_action :authenticate_request
  protect_from_forgery with: :null_session

  def current_user
    @current_user ||= User.find_by(id: @decoded_token['user_id']) if @decoded_token
  end

  def logged_in?
    !!current_user
  end

  def require_admin_user
    unless logged_in? && current_user.admin?
      redirect_to new_session_path, alert: 'You must be logged in and a valid admin to access this section.'
    end
  end

  def require_super_admin_user
    unless logged_in? && current_user.super_admin?
      redirect_to new_session_path, alert: 'You must be logged in and a valid super admin to access this section.'
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

  def current_tenant
    return unless logged_in?
    domain = current_user.email.split('@').last.split('.').first
    @current_tenant ||= Tenant.find_by(domain_name: domain)
  end

  def database_exists?(database_name)
    result = ActiveRecord::Base.connection.execute("SHOW DATABASES LIKE '#{database_name}'")
    result.any?
  end

  private

  def set_current_tenant
    return unless logged_in? && current_tenant

    Apartment::Tenant.switch!(current_tenant.domain_name)
  end

  def authenticate_request
    token = request.headers['Authorization']&.split(' ')&.last
    if token.present?
      begin
        @decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base).first
      rescue JWT::DecodeError
        # render json: { error: 'Invalid token' }, status: :unauthorized
      end
    else
      # render json: { error: 'Token not provided' }, status: :unauthorized
    end
  end
end
