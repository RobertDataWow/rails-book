# == Schema Information
#
# Table name: books
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string
#  release     :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Book < ApplicationRecord
  has_many :reviews, dependent: :destroy
  validates :name, presence: true
  validates :release, presence: true

  def review_comments
    reviews.pluck(:comment)
  end
end
