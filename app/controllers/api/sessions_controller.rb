class Api::SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:create]

  # POST /api/login
  api :POST, '/api/login', 'Log in a user'
  param :email, String, desc: 'User email address', required: true
  param :password, String, desc: 'User password', required: true
  def create
    email_domain = params[:email].split('@').last.split('.').first

    if database_exists?(email_domain)
      Apartment::Tenant.switch!(email_domain)
    end

    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { message: 'Login successful!', user: @user, token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  # DELETE /api/logout
  api :DELETE, '/api/logout', 'Log out the current user'
  def destroy
    render json: { message: 'Logged out successfully!' }, status: :ok
  end
end
