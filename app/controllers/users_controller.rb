class UsersController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    tenant = Tenant.create!(
      name: "DummyTenant",
      database_name: "dummy_db",
      database_username: "dummy_user",
      database_password: SecureRandom.hex(10),
      plan: "Free",
      status: true
    )

    @user = User.new(user_params.merge(tenant_id: tenant.id))

    # @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to dashboard_path, notice: 'Signup successful!'
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
