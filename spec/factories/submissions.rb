# frozen_string_literal: true

FactoryBot.define do
  factory :submission do
    association :task
    association :user
    note { Faker::Lorem.sentence(word_count: 6) }
    status { :pending }

    trait :accepted do
      status { :accepted }
    end

    trait :rejected do
      status { :rejected }
    end
  end
end
