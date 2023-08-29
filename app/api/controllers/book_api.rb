class BookApi < Grape::API
  resource :books do
    desc 'Get all books'
    get do
      books = Book.all
      BookSerializer.new(books).serializable_hash
    end

    desc 'Create a new book'
    params do
      requires :name, type: String
      requires :release, type: Date
      optional :description
    end
    post do
      book = Book.create(declared(params).merge(user: current_user))
      BookSerializer.new(book).serializable_hash
    end

    desc 'Get a specific book'
    get ':id' do
      book = Book.find_by(id: params[:id])
      error!('Not Found', 404) unless book
      BookSerializer.new(book).serializable_hash
    end

    desc 'Update a book'
    params do
      optional :name, type: String, desc: 'Book name'
      optional :release, type: Date, desc: 'Release date'
      optional :description
    end
    put ':id' do
      book = Book.find_by(id: params[:id])
      error!('Not Found', 404) unless book
      book.update(params)
      BookSerializer.new(book).serializable_hash
    end

    desc 'Delete a book'
    delete ':id' do
      book = Book.find_by(id: params[:id])
      error!('Not Found', 404) unless book
      book.destroy
      { message: 'Book deleted successfully' }
    end
  end
end
