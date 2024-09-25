class UserBudgetsController < ApplicationController
  before_action :set_user_budget, only: [:show, :edit, :update, :destroy]
  before_action :require_login
  before_action :load_expense_categories_and_currencies, only: [:new, :edit, :create, :update]

  def index
    @user_budgets = UserBudget.where(user_id: @current_user.id)
  end

  def new
    @user_budget = UserBudget.new
  end

  def edit
  end

  def create
    @user_budget = UserBudget.new(user_budget_params)
    @user_budget.user_id = @current_user.id

    if @user_budget.save
      redirect_to user_budgets_path, notice: "Budget was successfully created."
    else
      render :new
    end
  end

  def update
    if @user_budget.update(user_budget_params)
      redirect_to user_budgets_path, notice: "Budget was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @user_budget.destroy
    redirect_to user_budgets_path, notice: "Budget was successfully deleted."
  end

  private

  def set_user_budget
    @user_budget = UserBudget.find(params[:id])
  end

  def load_expense_categories_and_currencies
    @expense_categories = ExpenseCategory.all
    @currencies = Currency.all
  end

  def user_budget_params
    params.require(:user_budget).permit(:amount, :start_date, :end_date, :currency_id, :expense_category_id)
  end
end
