class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  has_many :user_budgets
  has_many :expenses
end

# == Schema Information
#
# Table name: users
#
#  id                  :bigint           not null, primary key
#  email               :string(255)      not null
#  is_admin            :boolean          default(FALSE)
#  is_blocked          :boolean          default(FALSE)
#  password_digest     :string(255)      not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  default_currency_id :bigint
#  tenant_id           :bigint           not null
#
# Indexes
#
#  index_users_on_default_currency_id  (default_currency_id)
#  index_users_on_email                (email) UNIQUE
#  index_users_on_tenant_id            (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (default_currency_id => currencies.id)
#  fk_rails_...  (tenant_id => tenants.id)
#
