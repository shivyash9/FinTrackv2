class CreateTenants < ActiveRecord::Migration[7.2]
  def change
    create_table :tenants do |t|
      t.string :name, null: false
      t.string :database_name, null: false
      t.string :database_username, null: false
      t.string :database_password, null: false
      t.boolean :status, default: true
      t.string :plan

      t.timestamps
    end
  end
end
