module Api
  class AnalyticsController < ApplicationController
    before_action :require_login

    # GET /api/analytics
    api :GET, '/api/analytics', 'Retrieve user spending analytics'
    description 'Fetches detailed analytics about the logged-in user\'s expenses, including category spending, monthly and daily expenses, and budget information.'

    def index
      @user = current_user
      @expenses = @user.expenses.includes(:expense_category, :currency)

      # Category Spending
      @category_spending = Hash.new(0)
      @expenses.each do |expense|
        @category_spending[expense.expense_category.name] += expense.amount
      end
      @graph_data = @category_spending.map { |category, total| { category: category, total: total } }

      # Monthly and Daily Expenses
      @monthly_expenses = @expenses.group_by { |e| e.expense_date.beginning_of_month }.map do |month, expenses|
        [month.strftime("%Y-%m"), expenses.sum(&:amount)]
      end.to_h

      @daily_expenses = @expenses.group_by { |e| e.expense_date.wday }.map do |day, expenses|
        [day, expenses.sum(&:amount)]
      end.to_h

      @monthly_expenses_graph_data = @monthly_expenses.map { |month, total| { month: month, total: total } }
      @daily_expenses_graph_data = @daily_expenses.map { |day, total| { day: day, total: total } }

      # Budgets and Mapped Expenses
      @budget_expense_data = []

      @user.user_budgets.includes(:expense_category).each do |budget|
        expenses_in_budget_period = @expenses.where(
          expense_category_id: budget.expense_category_id,
          expense_date: budget.start_date..budget.end_date
        )

        total_expenses = expenses_in_budget_period.sum(:amount)

        @budget_expense_data << {
          category: budget.expense_category.name,
          budget_amount: budget.amount,
          total_expenses: total_expenses,
          start_date: budget.start_date,
          end_date: budget.end_date,
          expenses: expenses_in_budget_period,
          id: budget.id
        }
      end

      render json: {
        category_spending: @graph_data,
        monthly_expenses: @monthly_expenses_graph_data,
        daily_expenses: @daily_expenses_graph_data,
        budget_expense_data: @budget_expense_data
      }
    end
  end
end
