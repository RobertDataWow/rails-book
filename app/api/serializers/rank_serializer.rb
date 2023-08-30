class RankSerializer
  include FastJsonapi::ObjectSerializer

  attributes :date
  attributes :book_ranks do |rank|
    BookRankSerializer.new(rank.book_ranks.order(:id)).as_json['data']
  end
end

class BookRankSerializer
  include FastJsonapi::ObjectSerializer

  attributes :view, :order_id
  attributes :book do |book_rank|
    BookSerializer.new(book_rank.book).as_json['data']['attributes']
  end
end
