FactoryBot.define do
  factory :review do
    comment { Faker::Restaurant.description }
    star { Faker::Number.between(from: 1.0, to: 5.0) }
    book { create(:book) }
  end
end
