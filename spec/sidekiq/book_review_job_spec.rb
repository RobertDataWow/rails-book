require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe BookReviewJob, type: :worker do
  describe '#perform' do
    it 'executes job correctly' do
      books = create_list(:book, 5)
      books.each { |book| book.cache_views!(rand(1..100)) }
      sorted_books = books.sort_by { |book| -book.cache_views }

      Sidekiq::Testing.inline! do
        BookReviewJob.perform_async

        expect(BookRank.count).to eq(5)
        expect(books.map(&:cache_views)).to all(eq(0))
        expect(sorted_books).to eq(BookRank.order(:order_id).map(&:book))
      end
    end
  end
end
