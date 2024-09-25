class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update]
  before_action :require_login

  def index
    @expenses = Expense.where(user_id: @current_user.id)
  end

  def new
    @expense = Expense.new
    @currencies = Currency.all
    @expense_categories = ExpenseCategory.all
  end

  def create
    @expense = Expense.new(expense_params)
    @expense.user_id = @current_user.id

    if @expense.save
      redirect_to expenses_path, notice: "Expense was successfully created."
    else
      @currencies = Currency.all
      @expense_categories = ExpenseCategory.all
      render :new
    end
  end

  def show
  end

  def edit
    @currencies = Currency.all
    @expense_categories = ExpenseCategory.all
  end

  def update
    if @expense.update(expense_params)
      redirect_to expenses_path, notice: "Expense was successfully updated."
    else
      @currencies = Currency.all
      @expense_categories = ExpenseCategory.all
      render :edit
    end
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:amount, :description, :currency_id, :expense_category_id, :expense_date)
  end
end
