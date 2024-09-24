class CreateCurrencies < ActiveRecord::Migration[7.2]
  def change
    create_table :currencies do |t|
      t.string :currency_code, null: false
      t.string :symbol, null: false

      t.timestamps
    end

    add_index :currencies, :currency_code, unique: true
  end
end
