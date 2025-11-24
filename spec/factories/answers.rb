# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    association :user
    association :submission
    message { Faker::Lorem.paragraph(sentence_count: 2) }
  end
end
