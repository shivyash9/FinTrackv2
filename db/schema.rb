# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_09_25_055118) do
  create_table "currencies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "currency_code", null: false
    t.string "symbol", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_code"], name: "index_currencies_on_currency_code", unique: true
  end

  create_table "expense_categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_expense_categories_on_name", unique: true
  end

  create_table "expenses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "description"
    t.bigint "expense_category_id", null: false
    t.bigint "currency_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "expense_date", null: false
    t.index ["currency_id"], name: "index_expenses_on_currency_id"
    t.index ["expense_category_id"], name: "index_expenses_on_expense_category_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "expenses_user_budgets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "expense_id", null: false
    t.bigint "user_budget_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id", "user_budget_id"], name: "index_expenses_user_budgets_on_expense_and_budget", unique: true
    t.index ["expense_id"], name: "index_expenses_user_budgets_on_expense_id"
    t.index ["user_budget_id"], name: "index_expenses_user_budgets_on_user_budget_id"
  end

  create_table "tenants", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "database_name", null: false
    t.string "database_username", null: false
    t.string "database_password", null: false
    t.boolean "status", default: true
    t.string "plan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "domain_name", null: false
  end

  create_table "user_budgets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "expense_category_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.bigint "currency_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_id"], name: "index_user_budgets_on_currency_id"
    t.index ["expense_category_id"], name: "index_user_budgets_on_expense_category_id"
    t.index ["user_id"], name: "index_user_budgets_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.bigint "tenant_id", null: false
    t.boolean "is_admin", default: false
    t.boolean "is_blocked", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "default_currency_id"
    t.index ["default_currency_id"], name: "index_users_on_default_currency_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["tenant_id"], name: "index_users_on_tenant_id"
  end

  add_foreign_key "expenses", "currencies"
  add_foreign_key "expenses", "expense_categories"
  add_foreign_key "expenses", "users"
  add_foreign_key "expenses_user_budgets", "expenses"
  add_foreign_key "expenses_user_budgets", "user_budgets"
  add_foreign_key "user_budgets", "currencies"
  add_foreign_key "user_budgets", "expense_categories"
  add_foreign_key "user_budgets", "users"
  add_foreign_key "users", "currencies", column: "default_currency_id"
  add_foreign_key "users", "tenants"
end
