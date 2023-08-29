class BookApi < Grape::API
  resource :books do
    desc 'GET /api/v1/books'
    get do
      books = Book.all
      BookSerializer.new(books).serializable_hash
    end

    desc 'POST /api/v1/books'
    params do
      requires :name, type: String
      requires :release, type: Date
      optional :description
    end
    post do
      book = Book.create(declared(params).merge(user: current_user))
      BookSerializer.new(book).serializable_hash
    end

    route_param :id do
      desc 'GET /api/v1/books/:id'
      get do
        book = Book.find_by(id: params[:id])
        error!('Not Found', 404) unless book
        BookSerializer.new(book).serializable_hash
      end

      desc 'PUT /api/v1/books/:id'
      params do
        optional :name, type: String, desc: 'Book name'
        optional :release, type: Date, desc: 'Release date'
        optional :description
      end
      put do
        book = Book.find_by(id: params[:id])
        error!('Not Found', 404) unless book
        book.update(params)
        BookSerializer.new(book).serializable_hash
      end

      desc 'DELETE /api/v1/books/:id'
      delete do
        book = Book.find_by(id: params[:id])
        error!('Not Found', 404) unless book
        book.destroy
        { message: 'Book deleted successfully' }
      end
    end
  end
end
