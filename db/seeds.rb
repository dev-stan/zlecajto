# frozen_string_literal: true

require 'faker'

puts 'Seeding database with random data...'

Faker::Config.locale = 'pl'

# --- Users ---
user_emails = %w[user1@example.com user2@example.com user3@example.com]
users = user_emails.map do |email|
  User.find_or_create_by!(email: email) do |u|
    u.password = 'password123'
    u.first_name = Faker::Name.first_name
    u.last_name  = Faker::Name.last_name
    u.address    = Faker::Address.full_address
    u.verified   = [true, false].sample
  end
end

# --- Tasks ---
CATEGORIES = %w[pets shopping delivery cleaning tutoring gardening it_misc moving house_care errands].freeze
STATUSES   = %w[draft open in_progress completed cancelled].freeze

desired_tasks = 30
current = Task.count
if current < desired_tasks
  (desired_tasks - current).times do
    category = CATEGORIES.sample
    title = case category
            when 'pets' then 'Wyprowadzanie psa'
            when 'shopping' then 'Zakupy spożywcze'
            when 'delivery' then 'Dostarczenie paczki'
            when 'cleaning' then 'Sprzątanie mieszkania'
            when 'tutoring' then 'Korepetycje z matematyki'
            when 'gardening' then 'Prace w ogrodzie'
            when 'it_misc' then 'Wsparcie IT'
            when 'moving' then 'Pomoc przy przeprowadzce'
            when 'house_care' then 'Drobne naprawy domowe'
            else 'Załatwienie drobnych sprawunków'
            end

    Task.create!(
      title: title,
      description: Faker::Lorem.paragraph(sentence_count: 3),
      salary: rand(20..200),
      status: (current < 5 ? 'open' : STATUSES.sample),
      category: category,
      user: users.sample
    )
    current += 1
  end
end

puts "Seed complete -> Users: #{User.count}, Tasks: #{Task.count}"
