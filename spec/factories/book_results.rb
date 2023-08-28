FactoryBot.define do
  factory :book do
    name { Faker::Restaurant.name }
    description { Faker::Restaurant.description }
    release { Faker::Date.between(from: '2014-09-23', to: '2014-09-25') }
    user { create(:user) }
  end
end
