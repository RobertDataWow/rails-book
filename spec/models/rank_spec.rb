# == Schema Information
#
# Table name: ranks
#
#  id   :bigint           not null, primary key
#  date :datetime
#
require 'rails_helper'

RSpec.describe Rank, type: :model do
  describe 'valid factory' do
    subject(:factory) { create(:rank) }

    it { is_expected.to be_valid }
  end
end
