class Expense < ApplicationRecord
end

# == Schema Information
#
# Table name: expenses
#
#  id                  :bigint           not null, primary key
#  amount              :decimal(10, 2)   not null
#  description         :string(255)
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
