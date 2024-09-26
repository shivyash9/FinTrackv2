FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    password { "password" }
    password_confirmation { "password" }
    is_admin { false }
    is_blocked { false }
  end
end
