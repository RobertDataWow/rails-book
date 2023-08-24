# == Schema Information
#
# Table name: books
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string
#  release     :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'valid factory' do
    subject(:factory) { create(:book) }

    it { is_expected.to be_valid }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:release) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:reviews) }
  end

  describe '#review_comments' do
    subject { book.review_comments }

    let(:book_a) { create(:book) }
    let(:book_b) { create(:book) }
    let(:review_a) { create(:review, book: book_a) }
    let(:review_b) { create(:review, book: book_a) }
    let(:review_c) { create(:review, book: book_a) }
    let(:review_aa) { create(:review, book: book_b) }
    let(:review_bb) { create(:review, book: book_b) }

    before do
      review_a
      review_b
      review_c
      review_aa
      review_bb
    end

    context 'for book_a' do
      let(:book) { book_a }
      it 'return book_a comments' do
        is_expected.to match_array([review_a.comment, review_b.comment, review_c.comment])
      end
    end

    context 'for book_b' do
      let(:book) { book_b }
      it 'return book_b comments' do
        is_expected.to match_array([review_aa.comment, review_bb.comment])
      end
    end
  end
end
