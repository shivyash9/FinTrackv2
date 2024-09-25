class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true

  has_many :user_budgets, dependent: :destroy
  has_many :expenses, dependent: :destroy

  # belongs_to :tenant
  # belongs_to :default_currency, class_name: 'Currency'

  def admin?
    is_admin
  end

  def super_admin?
    ####### Just a workaround for easy working
    is_admin && email.include?('pramata.com')
    ####### Just a workaround for easy working
  end
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
#
# Indexes
#
#  index_users_on_default_currency_id  (default_currency_id)
#  index_users_on_email                (email) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (default_currency_id => currencies.id)
#
