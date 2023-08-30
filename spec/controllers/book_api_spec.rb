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
    let(:user) { create(:user) }
    let(:book_params) { { name: 'TestPost', release: '28-02-2020', description: 'Test description' } }

    # Need to use this method to make the test send request again
    def post_request(params)
      post '/api/v1/books', headers: { Authorization: "Bearer #{user.auth_token}" }, params:
    end

    context 'good responses' do
      it 'creates a book' do
        expect { post_request(book_params) }.to change(Book, :count).by(1)
        expect(response.status).to eq(201)
      end
    end

    context 'bad responses' do
      it 'tries to create a book without name' do
        post_request({ release: '28-02-2020', description: 'Test description' })
        hash_body = JSON.parse(response.body).with_indifferent_access

        expect(response.status).to eq(400)
        expect(hash_body[:error]).to eq('name is missing')
      end

      it 'tries to create a book without release' do
        post_request({ name: 'TestPost', description: 'Test description' })
        hash_body = JSON.parse(response.body).with_indifferent_access

        expect(response.status).to eq(400)
        expect(hash_body[:error]).to eq('release is missing')
      end
    end
  end

  describe 'GET /api/v1/books/:id' do
    subject { get "/api/v1/books/#{book_id}", headers: { Authorization: "Bearer #{user.auth_token}" } }

    let(:user) { create(:user) }
    let(:book) { create(:book) }

    context 'good responses' do
      let(:book_id) { book.id }
      before { subject }

      it 'succeses status' do
        expect(response.status).to eq(200)
      end

      it 'returns correct response' do
        expect(response.body).to eq(BookSerializer.new(book).serialized_json)
      end
    end

    context 'bad responses' do
      let(:book_id) { 99 }
      before { subject }

      it 'returns not found' do
        hash_body = JSON.parse(response.body).with_indifferent_access

        expect(response.status).to eq(404)
        expect(hash_body[:error]).to eq('Not Found')
      end
    end
  end

  describe 'PUT /api/v1/books/:id' do
    subject do
      put "/api/v1/books/#{book_id}", headers: { Authorization: "Bearer #{user.auth_token}" }, params: updated_params
    end

    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:updated_params) { { name: 'UpdatedName', release: '10-01-2020', description: 'Updated Description' } }

    context 'good responses' do
      let(:book_id) { book.id }
      before { subject }

      it 'succeses status' do
        expect(response.status).to eq(200)
      end

      it 'changes data' do
        book.reload
        expect(book.name).to eq(updated_params[:name])
        expect(book.release).to eq(updated_params[:release])
        expect(book.description).to eq(updated_params[:description])
      end
    end

    context 'bad responses' do
      let(:book_id) { 99 }
      before { subject }

      it 'returns not found' do
        hash_body = JSON.parse(response.body).with_indifferent_access

        expect(response.status).to eq(404)
        expect(hash_body[:error]).to eq('Not Found')
      end
    end
  end

  describe 'DELETE /api/v1/books/:id' do
    subject do
      delete "/api/v1/books/#{book_id}", headers: { 'Authorization' => "Bearer #{user.auth_token}" }
    end

    let(:user) { create(:user) }
    let!(:book) { create(:book) }

    context 'good responses' do
      let(:book_id) { book.id }
      before { subject }

      it 'deletes a book' do
        expect(response.status).to eq(204)
      end
    end

    context 'bad responses' do
      let(:book_id) { 99 }
      before { subject }

      it 'returns not found' do
        hash_body = JSON.parse(response.body).with_indifferent_access

        expect(response.status).to eq(404)
        expect(hash_body[:error]).to eq('Not Found')
      end
    end
  end
end
