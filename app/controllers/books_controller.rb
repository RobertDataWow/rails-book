class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  def index
    @books = Book.all
  end

  def show; end

  def edit; end

  def new
    @book = Book.new
  end

  def update
    @book = Book.update(book_params)
    return redirect_to edit_book_path(errors: @book.errors.full_messages) unless @book.valid?

    redirect_to @book
  end

  def create
    @book = Book.create(book_params)
    return redirect_to new_book_path(errors: @book.errors.full_messages) unless @book.valid?

    redirect_to @book
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:name, :description, :release)
  end
end
