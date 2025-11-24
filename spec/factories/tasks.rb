# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph(sentence_count: 3) }
    salary { Faker::Number.between(from: 50, to: 500) }
    due_date { Faker::Time.forward(days: 5, period: :morning) }
    category { Task::CATEGORIES.sample }
    timeslot { Task::TIMESLOTS.sample }
    location { Task::LOCATIONS.sample }
    payment_method { Task::PAYMENT_METHODS.sample }
    association :user
  end
end
