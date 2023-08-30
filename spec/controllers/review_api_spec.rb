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
    subject do
      post '/api/v1/reviews', headers: { Authorization: "Bearer #{user.auth_token}" }, params: review_params
    end

    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:review_params) { { comment: 'Test comment', star: 4.0, book: book.id } }

    it 'creates a book' do
      expect { subject }.to change(Review, :count).by(1)
      expect(response.status).to eq(201)
    end
  end

  describe 'GET /api/v1/reviews/:id' do
    subject { get "/api/v1/reviews/#{review.id}", headers: { Authorization: "Bearer #{user.auth_token}" } }

    let(:user) { create(:user) }
    let(:review) { create(:review) }

    it 'succeses status' do
      subject
      expect(response.status).to eq(200)
    end

    it 'returns correct response' do
      subject
      expect(response.body).to eq(ReviewSerializer.new(review).serialized_json)
    end
  end

  describe 'PUT /api/v1/reviews/:id' do
    subject do
      put "/api/v1/reviews/#{review.id}", headers: { Authorization: "Bearer #{user.auth_token}" },
                                          params: updated_params
    end

    let(:user) { create(:user) }
    let(:review) { create(:review) }
    let(:updated_params) { { comment: 'Updated comment', star: 1.0 } }

    it 'succeses status' do
      subject
      expect(response.status).to eq(200)
    end

    it 'changes data' do
      subject

      review.reload
      expect(review.comment).to eq(updated_params[:comment])
      expect(review.star).to eq(updated_params[:star])
    end
  end

  describe 'DELETE /api/v1/reviews/:id' do
    subject do
      delete "/api/v1/reviews/#{review.id}", headers: { 'Authorization' => "Bearer #{user.auth_token}" }
    end

    let(:user) { create(:user) }
    let!(:review) { create(:review) }

    it 'deletes a book' do
      expect { subject }.to change(Review, :count).by(-1)
      expect(response.status).to eq(204)
    end
  end
end
