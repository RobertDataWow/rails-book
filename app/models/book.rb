class Book < ApplicationRecord
  has_many :reviews
  validates :name, precense: true
  validates :release, precense: true
end
