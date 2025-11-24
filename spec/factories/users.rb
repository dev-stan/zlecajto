# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_number { Faker::PhoneNumber.cell_phone_in_e164.delete_prefix('+') }
    email { Faker::Internet.email }
    password { 'password123' }
  end
end
