require 'rails_helper'

RSpec.describe TestService, type: :service do
  describe '.hello' do
    subject { described_class }

    context 'without arg' do
      it 'returns default' do
        expect(subject.test_return).to eq('default')
      end
    end

    context 'with arg' do
      it 'returns arg' do
        expect(subject.test_return('word')).to eq('word')
      end
    end
  end
end
