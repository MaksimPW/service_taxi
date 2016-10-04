require 'rails_helper'

RSpec.describe Inspection, type: :model do
  context '.inside_the_circle?' do
    it 'should receive' do
      expect(described_class).to receive(:inside_the_circle?)
      Inspection.inside_the_circle?(1,1,1,1,1)
    end

    it 'inside' do
      expect(Inspection.inside_the_circle?(1,1,1,1,1)).to eq true
    end

    it 'outside' do
      expect(Inspection.inside_the_circle?(0,0,1,1,1)).to eq false
    end

    it 'on' do
      expect(Inspection.inside_the_circle?(0,0.9,0,0,0.9)).to eq true
    end
  end
end
