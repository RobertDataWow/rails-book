require 'rails_helper'

RSpec.describe TestService, type: :service do
  describe '.hello' do
    subject { described_class }

    context 'no arg' do
      it 'return default' do
        expect(subject.test_return).to eq('default')
      end
    end

    context 'have arg' do
      it 'return arg' do
        expect(subject.test_return('word')).to eq('word')
      end
    end
  end
end
