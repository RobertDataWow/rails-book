require 'rails_helper'

RSpec.describe ApiController, type: :request do
  describe 'GET /api/v1/books' do
    subject { get '/api/v1/books', headers: { Authorization: "Bearer #{user.auth_token}" } }

    let(:user) { create(:user) }
    let(:books) { create_list(:book, 15) }

    before { books }

    it 'succeses status' do
      subject
      expect(response.status).to eq(200)
    end

    it 'returns correct response' do
      subject
      expect(response.body).to eq(BookSerializer.new(books.sort_by(&:id)).serialized_json)
    end
  end

  describe 'POST /api/v1/books' do
    subject do
      post '/api/v1/books', headers: { Authorization: "Bearer #{user.auth_token}" }, params: book_params
    end

    let(:user) { create(:user) }
    let(:book_params) { { name: 'TestPost', release: '28-02-2020', description: 'Test description' } }

    it 'creates a book' do
      expect { subject }.to change(Book, :count).by(1)
      expect(response.status).to eq(201)
    end
  end

  describe 'GET /api/v1/books/:id' do
    subject { get "/api/v1/books/#{book.id}", headers: { Authorization: "Bearer #{user.auth_token}" } }

    let(:user) { create(:user) }
    let(:book) { create(:book) }

    it 'succeses status' do
      subject
      expect(response.status).to eq(200)
    end

    it 'returns correct response' do
      subject
      expect(response.body).to eq(BookSerializer.new(book).serialized_json)
    end
  end

  describe 'PUT /api/v1/books/:id' do
    subject do
      put "/api/v1/books/#{book.id}", headers: { Authorization: "Bearer #{user.auth_token}" }, params: updated_params
    end

    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:updated_params) { { name: 'UpdatedName', release: '10-01-2020', description: 'Updated Description' } }

    it 'succeses status' do
      subject
      expect(response.status).to eq(200)
    end

    it 'changes data' do
      subject

      book.reload
      expect(book.name).to eq(updated_params[:name])
      expect(book.release).to eq(updated_params[:release])
      expect(book.description).to eq(updated_params[:description])
    end
  end

  describe 'DELETE /api/v1/books/:id' do
    subject do
      delete "/api/v1/books/#{book.id}", headers: { 'Authorization' => "Bearer #{user.auth_token}" }
    end

    let(:user) { create(:user) }
    let!(:book) { create(:book) }

    it 'deletes a book' do
      expect { subject }.to change(Book, :count).by(-1)
      expect(response.status).to eq(204)
    end
  end
end
