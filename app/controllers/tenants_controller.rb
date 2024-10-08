class TenantsController < ApplicationController
  before_action :set_tenant, only: %i[ show edit update destroy ]
  before_action :require_super_admin_user

  # GET /tenants or /tenants.json
  def index
    @tenants = Tenant.all
  end

  # GET /tenants/1 or /tenants/1.json
  def show
  end

  # GET /tenants/new
  def new
    @tenant = Tenant.new
  end

  # GET /tenants/1/edit
  def edit
  end

  # POST /tenants or /tenants.json
  def create
    @tenant = Tenant.new(tenant_params)

    respond_to do |format|
      if @tenant.save
        create_tenant_database(@tenant)

        format.html { redirect_to @tenant, notice: "Tenant was successfully created." }
        format.json { render :show, status: :created, location: @tenant }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tenant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tenants/1 or /tenants/1.json
  def update
    respond_to do |format|
      if @tenant.update(tenant_params)
        format.html { redirect_to @tenant, notice: "Tenant was successfully updated." }
        format.json { render :show, status: :ok, location: @tenant }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tenant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tenants/1 or /tenants/1.json
  def destroy
    delete_tenant_database(@tenant)
    @tenant.destroy

    respond_to do |format|
      format.html { redirect_to tenants_path, status: :see_other, notice: "Tenant was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tenant
      @tenant = Tenant.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tenant_params
      params.require(:tenant).permit(:database_name, :database_password, :database_username, :domain_name, :name, :plan, :status)
    end

    def create_tenant_database(tenant)
      Apartment::Tenant.create(tenant.database_name)
      Apartment::Tenant.switch(tenant.database_name) do
        ActiveRecord::Migration.maintain_test_schema!
      end
    end

    def delete_tenant_database(tenant)
      if database_exists?(tenant.database_name)
        Apartment::Tenant.drop(tenant.database_name)
        Rails.logger.info("Successfully dropped tenant database #{tenant.database_name}.")
      else
        Rails.logger.warn("Attempted to drop non-existent database #{tenant.database_name}.")
      end
    end

    private

    def database_exists?(database_name)
      result = ActiveRecord::Base.connection.execute("SHOW DATABASES LIKE '#{database_name}'")
      result.any?
    end
end
