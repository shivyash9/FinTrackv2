class Api::TenantsController < ApplicationController
  before_action :set_tenant, only: %i[show update destroy]
  before_action :require_super_admin_user

  # GET /api/tenants
  api :GET, '/api/tenants', 'Retrieve a list of all tenants'
  description 'Fetches all tenants in the system.'
  def index
    @tenants = Tenant.all
    render json: @tenants
  end

  # GET /api/tenants/:id
  api :GET, '/api/tenants/:id', 'Retrieve a specific tenant'
  param :id, :number, desc: 'Tenant ID', required: true
  description 'Fetches details of a specific tenant by ID.'
  def show
    render json: @tenant
  end

  # POST /api/tenants
  api :POST, '/api/tenants', 'Create a new tenant'
  param :database_name, String, desc: 'Name of the tenant database', required: true
  param :database_username, String, desc: 'Username for the tenant database', required: true
  param :database_password, String, desc: 'Password for the tenant database', required: true
  param :domain_name, String, desc: 'Domain name associated with the tenant', required: true
  param :name, String, desc: 'Name of the tenant', required: true
  param :plan, String, desc: 'Plan type of the tenant', required: true
  param :status, String, desc: 'Status of the tenant', required: true
  description 'Creates a new tenant and initializes its database.'
  def create
    @tenant = Tenant.new(tenant_params)

    if @tenant.save
      create_tenant_database(@tenant)
      render json: @tenant, status: :created, location: api_tenant_url(@tenant)
    else
      render json: @tenant.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/tenants/:id
  api :PATCH, '/api/tenants/:id', 'Update an existing tenant'
  param :id, :number, desc: 'Tenant ID', required: true
  param :database_name, String, desc: 'Name of the tenant database', required: false
  param :database_username, String, desc: 'Username for the tenant database', required: false
  param :database_password, String, desc: 'Password for the tenant database', required: false
  param :domain_name, String, desc: 'Domain name associated with the tenant', required: false
  param :name, String, desc: 'Name of the tenant', required: false
  param :plan, String, desc: 'Plan type of the tenant', required: false
  param :status, String, desc: 'Status of the tenant', required: false
  description 'Updates the specified tenant with the provided attributes.'
  def update
    if @tenant.update(tenant_params)
      render json: @tenant, status: :ok
    else
      render json: @tenant.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/tenants/:id
  api :DELETE, '/api/tenants/:id', 'Delete a tenant'
  param :id, :number, desc: 'Tenant ID', required: true
  description 'Deletes the specified tenant and its associated database.'
  def destroy
    delete_tenant_database(@tenant)
    @tenant.destroy
    head :no_content
  end

  private

  def set_tenant
    @tenant = Tenant.find(params[:id])
  end

  def tenant_params
    params.permit(:database_name, :database_password, :database_username, :domain_name, :name, :plan, :status)
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

  def database_exists?(database_name)
    result = ActiveRecord::Base.connection.execute("SHOW DATABASES LIKE '#{database_name}'")
    result.any?
  end
end
