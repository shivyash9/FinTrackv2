class CreateUserTable < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.references :tenant, null: false, foreign_key: true
      t.boolean :is_admin, default: false
      t.boolean :is_blocked, default: false

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
