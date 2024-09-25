class UserBudget < ApplicationRecord
  belongs_to :expense_category
  belongs_to :currency
  belongs_to :user

  validates :start_date, :end_date, presence: true
  validate :end_date_after_start_date
  has_and_belongs_to_many :expenses, join_table: :expenses_user_budgets

  def end_date_after_start_date
    if end_date.present? && start_date.present? && end_date < start_date
      errors.add(:end_date, "must be greater than or equal to the start date")
    end
  end
end

# == Schema Information
#
# Table name: user_budgets
#
#  id                  :bigint           not null, primary key
#  amount              :decimal(10, 2)   not null
#  end_date            :date             not null
#  start_date          :date             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  currency_id         :bigint           not null
#  expense_category_id :bigint           not null
#  user_id             :bigint           not null
#
# Indexes
#
#  index_user_budgets_on_currency_id          (currency_id)
#  index_user_budgets_on_expense_category_id  (expense_category_id)
#  index_user_budgets_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (currency_id => currencies.id)
#  fk_rails_...  (expense_category_id => expense_categories.id)
#  fk_rails_...  (user_id => users.id)
#
