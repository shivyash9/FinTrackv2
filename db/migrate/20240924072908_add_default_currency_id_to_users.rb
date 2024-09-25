class AddDefaultCurrencyIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :default_currency_id, :bigint
    add_foreign_key :users, :currencies, column: :default_currency_id
    add_index :users, :default_currency_id
  end
end
