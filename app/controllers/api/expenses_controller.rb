class Api::ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :update]
  before_action :require_login

  # GET /api/expenses
  api :GET, '/api/expenses', 'Retrieve a list of user expenses'
  description 'Fetches all expenses associated with the logged-in user.'
  def index
    @expenses = Expense.where(user_id: @current_user.id)
    render json: @expenses
  end

  # GET /api/expenses/new
  api :GET, '/api/expenses/new', 'Retrieve the form for creating a new expense'
  description 'Returns a new Expense object with necessary currencies and categories.'
  def new
    @expense = Expense.new
    @currencies = Currency.all
    @expense_categories = ExpenseCategory.all
    render json: { expense: @expense, currencies: @currencies, expense_categories: @expense_categories }
  end

  # POST /api/expenses
  api :POST, '/api/expenses', 'Create a new expense'
  param :amount, :number, desc: 'Expense amount', required: true
  param :description, String, desc: 'Description of the expense', required: false
  param :currency_id, :number, desc: 'ID of the currency used', required: true
  param :expense_category_id, :number, desc: 'ID of the associated expense category', required: true
  param :expense_date, String, desc: 'Date of the expense in YYYY-MM-DD format', required: true
  description 'Creates a new expense for the logged-in user.'
  def create
    @expense = Expense.new(expense_params)
    @expense.user_id = @current_user.id

    if @expense.save
      render json: @expense, status: :created, location: api_expense_url(@expense)
    else
      @currencies = Currency.all
      @expense_categories = ExpenseCategory.all
      render json: { errors: @expense.errors, currencies: @currencies, expense_categories: @expense_categories }, status: :unprocessable_entity
    end
  end

  # GET /api/expenses/:id
  api :GET, '/api/expenses/:id', 'Retrieve a specific expense'
  param :id, :number, desc: 'Expense ID', required: true
  description 'Fetches the details of a specific expense.'
  def show
    render json: @expense
  end

  # GET /api/expenses/:id/edit
  api :GET, '/api/expenses/:id/edit', 'Retrieve the form for editing an existing expense'
  param :id, :number, desc: 'Expense ID', required: true
  description 'Returns the Expense object with necessary currencies and categories for editing.'
  def edit
    @currencies = Currency.all
    @expense_categories = ExpenseCategory.all
    render json: { expense: @expense, currencies: @currencies, expense_categories: @expense_categories }
  end

  # PATCH/PUT /api/expenses/:id
  api :PATCH, '/api/expenses/:id', 'Update an existing expense'
  param :id, :number, desc: 'Expense ID', required: true
  param :amount, :number, desc: 'Expense amount', required: false
  param :description, String, desc: 'Description of the expense', required: false
  param :currency_id, :number, desc: 'ID of the currency used', required: false
  param :expense_category_id, :number, desc: 'ID of the associated expense category', required: false
  param :expense_date, String, desc: 'Date of the expense in YYYY-MM-DD format', required: false
  description 'Updates the specified expense with the provided attributes.'
  def update
    if @expense.update(expense_params)
      render json: @expense, status: :ok
    else
      @currencies = Currency.all
      @expense_categories = ExpenseCategory.all
      render json: { errors: @expense.errors, currencies: @currencies, expense_categories: @expense_categories }, status: :unprocessable_entity
    end
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.permit(:amount, :description, :currency_id, :expense_category_id, :expense_date).tap do |whitelisted|
      if whitelisted[:expense_date]
        whitelisted[:expense_date] = Date.parse(whitelisted[:expense_date]) rescue nil
      end
    end
  end
end
