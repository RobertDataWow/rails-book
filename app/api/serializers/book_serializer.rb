class BookSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :release, :description
  attributes :reviews do |book|
    ReviewSerializer.new(book.reviews).as_json['data']
  end
end
