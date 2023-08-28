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
      it 'unauthorizes access' do
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
        it 'raises error not found' do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'when user not sign in' do
      it 'unauthorizes access' do
        expect(subject.status).to eq(302)
        expect(subject).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE /book' do
    subject { delete :destroy, params: }

    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:user_book) { create(:book, user:) }
    before { sign_in user }

    context 'can delete own books' do
      let(:params) { { id: user_book.id } }

      it 'successes request' do
        expect(subject.status).to eq(302)
        expect(subject).to redirect_to(books_path)
      end
    end

    context 'cant delete others book' do
      let(:params) { { id: book.id } }

      it 'raises unathorize error' do
        expect { subject }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end

  describe 'PUT /book' do
    subject { put :update, params: }

    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:user_book) { create(:book, user:) }
    before { sign_in user }

    context 'can update own books' do
      let(:params) do
        {
          id: user_book.id,
          book: { name: 'Changed Name', description: 'changed', release: user_book.release, user: }
        }
      end

      it 'successes request' do
        expect(subject.status).to eq(302)
        expect(subject).to redirect_to(book_path(user_book))
        user_book.reload
        expect(user_book.name).to eq('Changed Name')
        expect(user_book.description).to eq('changed')
      end
    end

    context 'cant update others book' do
      let(:params) do
        {
          id: book.id,
          book: { name: 'Changed Name', description: 'changed', release: book.release, user: book.user }
        }
      end

      it 'raises unathorize error' do
        expect { subject }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
