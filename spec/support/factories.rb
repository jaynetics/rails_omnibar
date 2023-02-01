require 'factory_bot_rails'

FactoryBot.define do
  factory :user do
    first_name { 'John' }
    last_name { 'Doe' }
    sequence(:email) { |n| "person#{n}@example.com" }
    password { '12345678' }
  end
end
