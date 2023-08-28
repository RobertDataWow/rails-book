class Rank < ApplicationRecord
  has_many :book_ranks, dependent: :nullify
end
