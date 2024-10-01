class Api::UserBudgetsController < ApplicationController
  before_action :set_user_budget, only: [:show, :update, :destroy]
  before_action :require_login
  before_action :load_expense_categories_and_currencies, only: [:new, :edit, :create, :update]

  # GET /api/user_budgets
  api :GET, '/api/user_budgets', 'Retrieve a list of user budgets'
  description 'Fetches all budgets associated with the logged-in user.'
  def index
    @user_budgets = UserBudget.where(user_id: @current_user.id)
    render json: @user_budgets
  end

  # GET /api/user_budgets/:id
  api :GET, '/api/user_budgets/:id', 'Retrieve a specific user budget'
  param :id, :number, desc: 'User Budget ID', required: true
  description 'Fetches the specified user budget associated with the logged-in user.'
  def show
    render json: @user_budget
  end

  # POST /api/user_budgets
  api :POST, '/api/user_budgets', 'Create a new user budget'
  param :amount, :number, desc: 'Budget amount', required: true
  param :start_date, String, desc: 'Budget start date in YYYY-MM-DD format', required: true
  param :end_date, String, desc: 'Budget end date in YYYY-MM-DD format', required: true
  param :currency_id, :number, desc: 'ID of the currency used', required: true
  param :expense_category_id, :number, desc: 'ID of the associated expense category', required: true
  description 'Creates a new user budget for the logged-in user.'
  def create
    @user_budget = UserBudget.new(user_budget_params)
    @user_budget.user_id = @current_user.id

    if @user_budget.save
      render json: @user_budget, status: :created, location: api_user_budget_url(@user_budget)
    else
      render json: @user_budget.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/user_budgets/:id
  api :PATCH, '/api/user_budgets/:id', 'Update an existing user budget'
  param :id, :number, desc: 'User Budget ID', required: true
  param :amount, :number, desc: 'Budget amount', required: false
  param :start_date, String, desc: 'Budget start date in YYYY-MM-DD format', required: false
  param :end_date, String, desc: 'Budget end date in YYYY-MM-DD format', required: false
  param :currency_id, :number, desc: 'ID of the currency used', required: false
  param :expense_category_id, :number, desc: 'ID of the associated expense category', required: false
  description 'Updates the specified user budget with the provided attributes.'
  def update
    if @user_budget.update(user_budget_params)
      render json: @user_budget, status: :ok
    else
      render json: @user_budget.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/user_budgets/:id
  api :DELETE, '/api/user_budgets/:id', 'Delete a user budget'
  param :id, :number, desc: 'User Budget ID', required: true
  description 'Deletes the specified user budget.'
  def destroy
    @user_budget.destroy
    head :no_content
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
    params.permit(:amount, :start_date, :end_date, :currency_id, :expense_category_id).tap do |whitelisted|
      if whitelisted[:start_date].present?
        whitelisted[:start_date] = Date.parse(whitelisted[:start_date]) rescue nil
      end
      if whitelisted[:end_date].present?
        whitelisted[:end_date] = Date.parse(whitelisted[:end_date]) rescue nil
      end
    end
  end
end
