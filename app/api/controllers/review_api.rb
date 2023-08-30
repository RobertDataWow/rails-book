class ReviewApi < Grape::API
  resource :reviews do
    desc 'GET /api/v1/reviews'
    get do
      reviews = Review.all

      status 200
      ReviewSerializer.new(reviews)
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

      status 201
      ReviewSerializer.new(review)
    end

    route_param :id do
      desc 'GET /api/v1/reviews/:id'
      get do
        review = Review.find_by(id: params[:id])
        error!('Not Found', 404) unless review

        status 200
        ReviewSerializer.new(review)
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

        status 200
        ReviewSerializer.new(review)
      end

      desc 'DELETE /api/v1/reviews/:id'
      delete do
        review = Review.find_by(id: params[:id])
        error!('Not Found', 404) unless review
        review.destroy

        status 204
        {}
      end
    end
  end
end
