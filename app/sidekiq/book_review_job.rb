class BookReviewJob
  include Sidekiq::Job

  def perform(*_args)
    rank = Rank.create(date: Time.now)
    books = Book.all.sort_by { |book| -book.cache_views }
    books.each_with_index do |book, i|
      BookRank.create(
        rank:,
        book:,
        view: book.cache_views,
        order_id: i + 1
      )
      book.cache_views!(0)
    end
  end
end
