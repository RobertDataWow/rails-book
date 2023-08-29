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
  belongs_to :user, optional: true
  has_many :reviews, dependent: :destroy
  has_many :book_ranks, dependent: :nullify

  validates :name, presence: true
  validates :release, presence: true

  paginates_per 10

  def review_comments
    reviews.pluck(:comment)
  end

  def cache_views_key
    "books/#{id}/viewing_count"
  end

  def cache_views
    Rails.cache.fetch(cache_views_key) || 0
  end

  def cache_views!(force = nil)
    count = force.nil? ? cache_views + 1 : force
    Rails.cache.write(cache_views_key, count)
    count
  end
end
