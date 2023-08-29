FactoryBot.define do
  factory :book_rank do
    book { create(:book) }
    rank { create(:rank) }
    view { 0 }
    order_id { 1 }
  end
end
