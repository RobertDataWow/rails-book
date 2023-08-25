class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]
  before_action :authenticate_user!

  def index
    @books = Book.all
  end

  def show
    @review = Review.new
  end

  def edit; end

  def new
    @book = Book.new
  end

  def update
    authorize @book, policy_class: BookPolicy
    if @book.update(book_params)
      redirect_to @book
    else
      redirect_to edit_book_path(errors: @book.errors.full_messages)
    end
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book
    else
      redirect_to new_book_path(errors: @book.errors.full_messages)
    end
  end

  def destroy
    authorize @book, policy_class: BookPolicy
    @book.destroy
    redirect_to books_path
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:name, :description, :release).merge(user: current_user)
  end
end
