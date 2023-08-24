require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'valid factory' do
    subject(:factory) { create(:user) }

    it { is_expected.to be_valid }
  end
end
