class ReviewApi < Grape::API
  resource :reviews do
    desc 'Get all reviews'
    get do
      reviews = Review.all
      ReviewSerializer.new(reviews).serializable_hash
    end

    desc 'Create a new review'
    params do
      requires :book, type: Integer
      requires :comment, type: String
      requires :star, type: Float
    end
    post do
      book = Book.find_by(id: params[:book])
      error!('Book Not Found', 404) unless book
      params[:book] = book
      review = Review.create(declared(params).merge(user: current_user))
      ReviewSerializer.new(review).serializable_hash
    end

    desc 'Get a specific review'
    get ':id' do
      review = Review.find_by(id: params[:id])
      error!('Not Found', 404) unless review
      ReviewSerializer.new(review).serializable_hash
    end

    desc 'Update a review'
    params do
      optional :comment, type: String
      optional :star, type: Float
    end
    put ':id' do
      review = Review.find_by(id: params[:id])
      error!('Not Found', 404) unless review
      review.update(params)
      ReviewSerializer.new(review).serializable_hash
    end

    desc 'Delete a review'
    delete ':id' do
      review = Review.find_by(id: params[:id])
      error!('Not Found', 404) unless review
      review.destroy
      { message: 'Review deleted successfully' }
    end
  end
end
