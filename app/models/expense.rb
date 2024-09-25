class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :currency
  belongs_to :expense_category

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :currency_id, presence: true
  validates :expense_category_id, presence: true

  has_and_belongs_to_many :user_budgets, join_table: :expenses_user_budgets

  after_create :map_to_user_budgets

  private

  def map_to_user_budgets
    budgets = UserBudget.where(
      expense_category_id: expense_category_id,
      start_date: ..expense_date,
      end_date: expense_date..
    )

    budgets.each do |budget|
      unless user_budgets.include?(budget)
        user_budgets << budget
      end
    end
  end
end

# == Schema Information
#
# Table name: expenses
#
#  id                  :bigint           not null, primary key
#  amount              :decimal(10, 2)   not null
#  description         :string(255)
#  expense_date        :date             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  currency_id         :bigint           not null
#  expense_category_id :bigint           not null
#  user_id             :bigint           not null
#
# Indexes
#
#  index_expenses_on_currency_id          (currency_id)
#  index_expenses_on_expense_category_id  (expense_category_id)
#  index_expenses_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (currency_id => currencies.id)
#  fk_rails_...  (expense_category_id => expense_categories.id)
#  fk_rails_...  (user_id => users.id)
#
