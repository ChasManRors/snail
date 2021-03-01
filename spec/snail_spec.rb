# create your sample spec in the root/spec dir
require 'spec_helper'
require_relative '../snail'

describe "Snail" do
  let(:input) { [[1, 2, 3], [4, 5, 6], [7, 8, 9]] }
  let(:expected) { [1, 2, 3, 6, 9, 8, 7, 4, 5] }

  context 'given an nxn array' do
    it 'returns snail path sequence through array' do
      expect(snail(input)).to eq(expected)
    end
  end
end
