class AddDomainInTenants < ActiveRecord::Migration[7.0]
  def change
    add_column :tenants, :domain_name, :string, null:false
  end
end
