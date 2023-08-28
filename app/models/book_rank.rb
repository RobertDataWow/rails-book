# == Schema Information
#
# Table name: book_ranks
#
#  id         :bigint           not null, primary key
#  view       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :bigint           not null
#  order_id   :integer
#  rank_id    :bigint           not null
#
# Indexes
#
#  index_book_ranks_on_book_id  (book_id)
#  index_book_ranks_on_rank_id  (rank_id)
#
# Foreign Keys
#
#  fk_rails_...  (book_id => books.id)
#  fk_rails_...  (rank_id => ranks.id)
#
class BookRank < ApplicationRecord
  belongs_to :book
  belongs_to :rank
end
