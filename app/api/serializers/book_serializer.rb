class BookSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :release, :description
end
