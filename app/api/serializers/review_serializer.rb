class ReviewSerializer
  include FastJsonapi::ObjectSerializer

  attributes :user_id, :book_id, :comment, :star
end
