# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'Marta' }
    last_name { 'Skubis' }
    phone_number { '334234123' }
    email { Faker::Internet.email }
    password { 'password123' }
  end
end
