class DashboardController < ApplicationController
  before_action :require_login

  def index
    @user_budgets = UserBudget.where(user_id: @current_user.id)
    @expenses = Expense.where(user_id: @current_user.id)

    @total_budget = @user_budgets.sum(:amount)
    @total_expenses = @expenses.sum(:amount)

    @weekly_expenses = @expenses.group_by_week(:expense_date).sum(:amount)
    @monthly_expenses = @expenses.group_by_month(:expense_date).sum(:amount)

    # Expenses by category
    @expenses_by_category = @expenses.group(:expense_category_id).sum(:amount)

    # For users with budgets, compare spending with budget
    if @user_budgets.any?
      @budget_data = @user_budgets.map do |budget|
        spent = @expenses.where(expense_category_id: budget.expense_category_id)
                         .where("expense_date BETWEEN ? AND ?", budget.start_date, budget.end_date)
                         .sum(:amount)

        {
          category: ExpenseCategory.find(budget.expense_category_id).name,
          budget_amount: budget.amount,
          spent_amount: spent,
          exceeded: spent > budget.amount
        }
      end
    end
  end
end
