class Book < ApplicationRecord
  has_many :reviews
  validates :name, presence: true
  validates :release, presence: true
end
