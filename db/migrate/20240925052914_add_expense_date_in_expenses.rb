class AddExpenseDateInExpenses < ActiveRecord::Migration[7.0]
  def change
    add_column :expenses, :expense_date, :date, null: false
  end
end
