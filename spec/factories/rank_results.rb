FactoryBot.define do
  factory :rank do
    date { Faker::Time.between(from: DateTime.now - 360, to: DateTime.now) }
  end
end
