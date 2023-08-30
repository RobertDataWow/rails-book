class BookApi < Grape::API
  resource :books do
    desc 'GET /api/v1/books'
    get do
      books = Book.all

      status 200
      BookSerializer.new(books)
    end

    desc 'POST /api/v1/books'
    params do
      requires :name, type: String
      requires :release, type: Date
      optional :description
    end
    post do
      book = Book.create(declared(params).merge(user: current_user))

      status 201
      BookSerializer.new(book)
    end

    route_param :id do
      desc 'GET /api/v1/books/:id'
      get do
        book = Book.find_by(id: params[:id])
        error!('Not Found', 404) unless book

        status 200
        BookSerializer.new(book)
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

        status 200
        BookSerializer.new(book)
      end

      desc 'DELETE /api/v1/books/:id'
      delete do
        book = Book.find_by(id: params[:id])
        error!('Not Found', 404) unless book
        book.destroy

        status 204
        {}
      end
    end
  end
end
