require 'rails_helper'

RSpec.describe BookRank, type: :model do
  describe 'valid factory' do
    subject(:factory) { create(:book_rank) }

    it { is_expected.to be_valid }
  end

  describe 'asociations' do
    it { is_expected.to belong_to(:book) }
    it { is_expected.to belong_to(:rank) }
  end
end
