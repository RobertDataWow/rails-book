class ReviewSerializer
  include FastJsonapi::ObjectSerializer

  attributes :comment, :star
end
