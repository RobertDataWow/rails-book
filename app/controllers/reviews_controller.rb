class ReviewsController < ApplicationController
  before_action :set_review, only: %i[edit update destroy]
  before_action :set_book, only: %i[edit destroy create]

  def create
    @review = @book.reviews.new(review_params)
    if @review.save
      redirect_to @book
    else
      redirect_to book_path(@book, review_errors: @review.errors.full_messages)
    end
  end

  def edit; end

  def update
    authorize @review
    if @review.update(review_params)
      redirect_to book_path(@review.book)
    else
      redirect_to edit_review_path(review_errors: review.errors.full_messages)
    end
  end

  def destroy
    authorize @review
    @review.destroy
    redirect_to book_path(@book)
  end

  private

  def review_params
    params.require(:review).permit(:comment, :star).merge(user: current_user)
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def set_book
    @book = Book.find(params[:book_id])
  end
end
