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
