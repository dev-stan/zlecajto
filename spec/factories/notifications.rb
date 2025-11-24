# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    association :user
    subject { Faker::Lorem.sentence(word_count: 4) }
    read_at { nil }
    notifiable { nil }
  end
end
