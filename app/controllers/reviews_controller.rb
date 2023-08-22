class ReviewsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @book.reviews.create(review_params)
    redirect_to @book
  end

  def review_params
    params.require(:review).permit(:comment, :star)
  end
end
