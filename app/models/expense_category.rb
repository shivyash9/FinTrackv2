class ExpenseCategory < ApplicationRecord
end

# == Schema Information
#
# Table name: expense_categories
#
#  id          :bigint           not null, primary key
#  description :string(255)      not null
#  name        :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_expense_categories_on_name  (name) UNIQUE
#
