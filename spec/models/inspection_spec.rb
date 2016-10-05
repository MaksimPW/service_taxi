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

  context '.summary_build_route' do
    let!(:status1) { create(:status_car, geo_lon: 30.3165129, geo_lat: 59.9305177 ) }
    let!(:status2) { create(:status_car, geo_lon: 30.34893, geo_lat: 59.91395) }

    it 'should receive' do
      expect(described_class).to receive(:summary_build_route)
      Inspection.summary_build_route([status1.id, status2.id])
    end

    %w(length).each do |attr|
      it "return #{attr}" do
        expect(Inspection.summary_build_route([status1.id, status2.id])).to include("#{attr}")
      end
    end
  end
end
