class CreateUserBudgets < ActiveRecord::Migration[7.2]
  def change
    create_table :user_budgets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :expense_category, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.references :currency, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date, null: false

      t.timestamps
    end
  end
end
