class CreateExpensesUserBudgets < ActiveRecord::Migration[7.2]
  def change
    create_table :expenses_user_budgets do |t|
      t.references :expense, null: false, foreign_key: true
      t.references :user_budget, null: false, foreign_key: true

      t.timestamps
    end

    add_index :expenses_user_budgets, [:expense_id, :user_budget_id], unique: true, name: 'index_expenses_user_budgets_on_expense_and_budget'
  end
end
