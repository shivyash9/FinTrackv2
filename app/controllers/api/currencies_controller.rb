class Api::CurrenciesController < ApplicationController
  before_action :set_currency, only: %i[show update destroy]
  before_action :require_admin_user

  # GET /api/currencies
  api :GET, '/currencies', 'Retrieve a list of all currencies'
  def index
    @currencies = Currency.all
    render json: @currencies
  end

  # GET /api/currencies/:id
  api :GET, '/currencies/:id', 'Retrieve a specific currency by ID'
  param :id, :number, desc: 'ID of the currency', required: true
  def show
    render json: @currency
  end

  # POST /api/currencies
  api :POST, '/currencies', 'Create a new currency'
  param :currency_code, String, desc: 'The currency code (e.g., USD)', required: true
  param :symbol, String, desc: 'The symbol of the currency (e.g., $)', required: true
  def create
    @currency = Currency.new(currency_params)

    if @currency.save
      render json: @currency, status: :created, location: api_currency_url(@currency)
    else
      render json: @currency.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/currencies/:id
  api :PATCH, '/currencies/:id', 'Update an existing currency'
  param :id, :number, desc: 'ID of the currency', required: true
  param :currency_code, String, desc: 'The updated currency code', required: false
  param :symbol, String, desc: 'The updated symbol of the currency', required: false
  def update
    if @currency.update(currency_params)
      render json: @currency
    else
      render json: @currency.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/currencies/:id
  api :DELETE, '/currencies/:id', 'Delete a currency'
  param :id, :number, desc: 'ID of the currency', required: true
  def destroy
    @currency.destroy!
    head :no_content
  end

  private

  def set_currency
    @currency = Currency.find(params[:id])
  end

  def currency_params
    params.require(:currency).permit(:currency_code, :symbol)
  end
end
