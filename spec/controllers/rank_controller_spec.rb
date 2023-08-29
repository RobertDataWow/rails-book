RSpec.describe RanksController, type: :controller do
  describe 'GET /index' do
    subject { get :index }

    let(:user) { create(:user) }
    let(:ranks) { create_list(:rank, 2) }

    before { sign_in user }

    it 'returns a successful response' do
      expect(subject.status).to eq(200)
    end

    context 'returns correct pagination' do
      it 'pages 1' do
        get :index, params: { page: 1 }
        expect(assigns(:ranks)).to eq(Rank.page(1))
      end

      it 'pages 2' do
        get :index, params: { page: 2 }
        expect(assigns(:ranks)).to eq(Rank.page(2))
      end
    end
  end
end
