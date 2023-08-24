require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  describe 'GET /index' do
    subject { get :index }

    let(:user) { create(:user) }
    let(:books) { create_list(:book, 10) }

    context 'when user sign in' do
      before { sign_in user }

      it 'returns all books' do
        expect(subject.status).to eq(200)
        expect(assigns(:books)).to eq(Book.all)
      end
    end

    context 'when user not sign in' do
      it 'unauthorize access' do
        expect(subject.status).to eq(302)
        expect(subject).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /show' do
    subject { get :show, params: }

    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:params) { { id: book.id } }

    context 'when user sign in' do
      before { sign_in user }

      context 'book exist' do
        it 'returns book' do
          expect(subject.status).to eq(200)
          expect(assigns(:book)).to eq(Book.find(book.id))
        end
      end

      context 'book not exist' do
        let(:params) { { id: -1 } }
        it 'raise error not found' do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'when user not sign in' do
      it 'unauthorize access' do
        expect(subject.status).to eq(302)
        expect(subject).to redirect_to(new_user_session_path)
      end
    end
  end
end
