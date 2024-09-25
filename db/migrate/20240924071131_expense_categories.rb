class ExpenseCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :expense_categories do |t|
      t.string :name, null: false
      t.string :description, null: false

      t.timestamps
    end

    add_index :expense_categories, :name, unique: true
  end
end
