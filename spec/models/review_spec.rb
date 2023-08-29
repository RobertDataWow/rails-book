# == Schema Information
#
# Table name: reviews
#
#  id         :bigint           not null, primary key
#  comment    :text
#  star       :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :integer          not null
#  user_id    :bigint
#
# Indexes
#
#  index_reviews_on_book_id  (book_id)
#  index_reviews_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (book_id => books.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'valid factory' do
    subject(:factory) { create(:review) }

    it { is_expected.to be_valid }
  end

  describe 'asociations' do
    it { is_expected.to belong_to(:book) }
  end
end
