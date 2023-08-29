class ReviewApi < Grape::API
  resource :reviews do
    desc 'GET /api/v1/reviews'
    get do
      reviews = Review.all
      ReviewSerializer.new(reviews).serializable_hash
    end

    desc 'POST /api/v1/reviews'
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

    route_param :id do
      desc 'GET /api/v1/reviews/:id'
      get do
        review = Review.find_by(id: params[:id])
        error!('Not Found', 404) unless review
        ReviewSerializer.new(review).serializable_hash
      end

      desc 'PUT /api/v1/reviews/:id'
      params do
        optional :comment, type: String
        optional :star, type: Float
      end
      put do
        review = Review.find_by(id: params[:id])
        error!('Not Found', 404) unless review
        review.update(params)
        ReviewSerializer.new(review).serializable_hash
      end

      desc 'DELETE /api/v1/reviews/:id'
      delete do
        review = Review.find_by(id: params[:id])
        error!('Not Found', 404) unless review
        review.destroy
        { message: 'Review deleted successfully' }
      end
    end
  end
end
