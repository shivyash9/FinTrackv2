class Currency < ApplicationRecord
end

# == Schema Information
#
# Table name: currencies
#
#  id            :bigint           not null, primary key
#  currency_code :string(255)      not null
#  symbol        :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_currencies_on_currency_code  (currency_code) UNIQUE
#
