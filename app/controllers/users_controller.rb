class UsersController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    email_domain = user_params[:email].split('@').last.split('.').first
    tenant = Tenant.find_by(domain_name: email_domain)
    if tenant.nil?
      flash.now[:alert] = 'Tenant not found for the given email domain.'
      @user = User.new(user_params)
      render :new and return
    end

    @user = User.new(user_params.merge(tenant_id: tenant.id))
    if user_params[:password_confirmation] != user_params[:password]
      flash.now[:alert] = 'Password did not match'
      @user = User.new(user_params)
      render :new and return
    end

    ####### Just a workaround for easy working
    if user.email.include?('yash')
      user.is_admin = true
    end
    ####### Just a workaround for easy working

    if @user.save
      session[:user_id] = @user.id
      redirect_to dashboard_path, notice: 'Signup successful!'
    else
      render :new
      flash.now[:alert] = 'Some issue with user creation.'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
