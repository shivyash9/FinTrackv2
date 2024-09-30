class Api::ExpenseCategoriesController < ApplicationController
  before_action :set_expense_category, only: %i[show update destroy]
  before_action :require_admin_user

  # GET /api/expense_categories
  api :GET, '/api/expense_categories', 'Retrieve a list of all expense categories'
  def index
    @expense_categories = ExpenseCategory.all
    render json: @expense_categories
  end

  # GET /api/expense_categories/:id
  api :GET, '/api/expense_categories/:id', 'Retrieve a specific expense category by ID'
  param :id, :number, desc: 'ID of the expense category', required: true
  def show
    render json: @expense_category
  end

  # POST /api/expense_categories
  api :POST, '/api/expense_categories', 'Create a new expense category'
  param :name, String, desc: 'The name of the expense category', required: true
  param :description, String, desc: 'The description of the expense category', required: false
  def create
    @expense_category = ExpenseCategory.new(expense_category_params)

    if @expense_category.save
      render json: @expense_category, status: :created, location: api_expense_category_url(@expense_category)
    else
      render json: @expense_category.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/expense_categories/:id
  api :PATCH, '/api/expense_categories/:id', 'Update an existing expense category'
  param :id, :number, desc: 'ID of the expense category', required: true
  param :name, String, desc: 'The updated name of the expense category', required: false
  param :description, String, desc: 'The updated description of the expense category', required: false
  def update
    if @expense_category.update(expense_category_params)
      render json: @expense_category
    else
      render json: @expense_category.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/expense_categories/:id
  api :DELETE, '/api/expense_categories/:id', 'Delete an expense category'
  param :id, :number, desc: 'ID of the expense category', required: true
  def destroy
    @expense_category.destroy!
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_expense_category
    @expense_category = ExpenseCategory.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def expense_category_params
    params.require(:expense_category).permit(:name, :description)
  end
end
