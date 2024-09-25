# == Schema Information
#
# Table name: fin_track_development.tenants
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
FactoryBot.define do
  factory :tenant do
    name { "Test Tenant" }
    database_name { "test_db" }
    database_username { "test_user" }
    database_password { "password" }
    domain_name { "gmail.com" }
    plan { "basic" }
    status { true }
  end
end
