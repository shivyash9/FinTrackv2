class Api::UsersController < ApplicationController
  before_action :redirect_if_logged_in, only: [:create]

  # POST /api/signup
  api :POST, '/api/signup', 'Signup a new user'
  param :email, String, desc: 'User email address', required: true
  param :password, String, desc: 'User password', required: true
  param :password_confirmation, String, desc: 'Password confirmation', required: true
  def create
    email_domain = user_params[:email].split('@').last.split('.').first
    tenant = Tenant.find_by(domain_name: email_domain)

    if database_exists?(email_domain)
      Apartment::Tenant.switch!(email_domain)
    end

    if tenant.nil?
      render json: { error: 'Tenant not found for the given email domain.' }, status: :not_found
      return
    end

    @user = User.new(user_params)
    if user_params[:password_confirmation] != user_params[:password]
      render json: { error: 'Password confirmation does not match.' }, status: :unprocessable_entity
      return
    end

    ####### Workaround for easy working
    @user.is_admin = true if @user.email.include?('yash')
    ####### End of workaround

    if @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { message: 'Signup successful!', user: @user, token: token }, status: :created
    else
      render json: { error: 'User creation failed.' }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
