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
#  user_id     :bigint
#
# Indexes
#
#  index_books_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Book < ApplicationRecord
  belongs_to :user
  has_many :reviews, dependent: :destroy

  validates :name, presence: true
  validates :release, presence: true

  paginates_per 10

  def review_comments
    reviews.pluck(:comment)
  end

  def review_stars
    cache_key = "book_#{id}_review_stars/#{reviews.latest_update_str}"
    puts cache_key
    avg = Rails.cache.fetch(cache_key) { reviews.average(:star) }
    avg.nil? ? '☆☆☆☆☆' : ('★' * avg.floor).ljust(5, '☆')
  end
end
