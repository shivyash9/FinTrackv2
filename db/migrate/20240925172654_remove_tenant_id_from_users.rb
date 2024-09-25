class RemoveTenantIdFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :tenant_id
  end
end
