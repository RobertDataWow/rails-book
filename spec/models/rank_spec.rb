require 'rails_helper'

RSpec.describe Rank, type: :model do
  describe 'valid factory' do
    subject(:factory) { create(:rank) }

    it { is_expected.to be_valid }
  end
end
