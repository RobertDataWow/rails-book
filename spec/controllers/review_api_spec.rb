require 'rails_helper'

RSpec.describe ApiController, type: :request do
  describe 'GET /api/v1/reviews' do
    subject { get '/api/v1/reviews', headers: { Authorization: "Bearer #{user.auth_token}" } }

    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:reviews) { create_list(:review, 15, book:) }

    before { reviews }

    it 'succeses status' do
      subject
      expect(response.status).to eq(200)
    end

    it 'returns correct response' do
      subject
      expect(response.body).to eq(ReviewSerializer.new(reviews.sort_by(&:id)).serialized_json)
    end
  end

  describe 'POST /api/v1/reviews' do
    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:review_params) { { comment: 'Test comment', star: 4.0, book: book.id } }

    def post_request(params)
      post '/api/v1/reviews', headers: { Authorization: "Bearer #{user.auth_token}" }, params:
    end

    context 'good responses' do
      it 'creates a review' do
        expect { post_request(review_params) }.to change(Review, :count).by(1)
        expect(response.status).to eq(201)
      end
    end

    context 'bad responses' do
      it 'tries to create a review without book' do
        post_request({ comment: 'Test comment', star: 4.0 })
        hash_body = JSON.parse(response.body).with_indifferent_access

        expect(response.status).to eq(400)
        expect(hash_body[:error]).to eq('book is missing')
      end

      it 'tries to create a review without comment' do
        post_request({ star: 4.0, book: book.id })
        hash_body = JSON.parse(response.body).with_indifferent_access

        expect(response.status).to eq(400)
        expect(hash_body[:error]).to eq('comment is missing')
      end

      it 'tries to create a review without star' do
        post_request({ comment: 'Test comment', book: book.id })
        hash_body = JSON.parse(response.body).with_indifferent_access

        expect(response.status).to eq(400)
        expect(hash_body[:error]).to eq('star is missing')
      end
    end
  end

  describe 'GET /api/v1/reviews/:id' do
    subject { get "/api/v1/reviews/#{review_id}", headers: { Authorization: "Bearer #{user.auth_token}" } }

    let(:user) { create(:user) }
    let(:review) { create(:review) }

    context 'good responses' do
      let(:review_id) { review.id }
      before { subject }

      it 'succeses status' do
        expect(response.status).to eq(200)
      end

      it 'returns correct response' do
        expect(response.body).to eq(ReviewSerializer.new(review).serialized_json)
      end
    end

    context 'bad responses' do
      let(:review_id) { 99 }
      before { subject }

      it 'returns not found' do
        hash_body = JSON.parse(response.body).with_indifferent_access

        expect(response.status).to eq(404)
        expect(hash_body[:error]).to eq('Not Found')
      end
    end
  end

  describe 'PUT /api/v1/reviews/:id' do
    subject do
      put "/api/v1/reviews/#{review_id}", headers: { Authorization: "Bearer #{user.auth_token}" },
                                          params: updated_params
    end

    let(:user) { create(:user) }
    let(:review) { create(:review) }
    let(:updated_params) { { comment: 'Updated comment', star: 1.0 } }

    context 'good responses' do
      let(:review_id) { review.id }
      before { subject }

      it 'succeses status' do
        expect(response.status).to eq(200)
      end

      it 'changes data' do
        review.reload
        expect(review.comment).to eq(updated_params[:comment])
        expect(review.star).to eq(updated_params[:star])
      end
    end

    context 'bad responses' do
      let(:review_id) { 99 }
      before { subject }

      it 'returns not found' do
        hash_body = JSON.parse(response.body).with_indifferent_access

        expect(response.status).to eq(404)
        expect(hash_body[:error]).to eq('Not Found')
      end
    end
  end

  describe 'DELETE /api/v1/reviews/:id' do
    subject do
      delete "/api/v1/reviews/#{review_id}", headers: { 'Authorization' => "Bearer #{user.auth_token}" }
    end

    let(:user) { create(:user) }
    let!(:review) { create(:review) }

    context 'good responses' do
      let(:review_id) { review.id }
      before { subject }

      it 'deletes a book' do
        expect(response.status).to eq(204)
      end
    end

    context 'bad responses' do
      let(:review_id) { 99 }
      before { subject }

      it 'returns not found' do
        hash_body = JSON.parse(response.body).with_indifferent_access

        expect(response.status).to eq(404)
        expect(hash_body[:error]).to eq('Not Found')
      end
    end
  end
end
