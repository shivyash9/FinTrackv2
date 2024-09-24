class Tenant < ApplicationRecord
end

# == Schema Information
#
# Table name: tenants
#
#  id                :bigint           not null, primary key
#  database_name     :string(255)      not null
#  database_password :string(255)      not null
#  database_username :string(255)      not null
#  domain_name       :string(255)      not null
#  name              :string(255)      not null
#  plan              :string(255)
#  status            :boolean          default(TRUE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
