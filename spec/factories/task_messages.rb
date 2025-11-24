# frozen_string_literal: true

FactoryBot.define do
  factory :task_message do
    association :task
    association :user
    body { Faker::Lorem.paragraph(sentence_count: 2) }
    message_type { :question }

    trait :reply do
      association :parent, factory: :task_message
      message_type { :reply }
    end
  end
end
