require 'rails_helper'

RSpec.describe ApiController, type: :request do
  describe 'GET /api/v1/ranks' do
    subject { get '/api/v1/ranks', headers: { Authorization: "Bearer #{user.auth_token}" } }

    let(:user) { create(:user) }
    let(:rank) { create(:rank) }
    let(:books) { create_list(:book, 10) }
    let(:book_ranks) do
      books.each_with_index do |book, i|
        create(:book_rank, book:, rank:, order_id: i + 1)
      end
    end

    it 'succeses status' do
      subject
      expect(response.status).to eq(200)
    end

    it 'returns correct response' do
      subject
      expect(response.body).to eq(RankSerializer.new(Rank.all).serialized_json)
    end
  end
end
