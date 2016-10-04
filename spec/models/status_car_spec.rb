require 'rails_helper'

RSpec.describe StatusCar, type: :model do
  context '#get_places' do

    let(:place_type1) { FactoryGirl.create(:place_type, id: 1) }
    let(:place_type2) { FactoryGirl.create(:place_type, id: 1) }
    let(:in_place) { FactoryGirl.create(:place, lat: 59.9342802, lon: 30.3350986, radius: 1, place_type_id: place_type1.id) }
    let(:out_place) { FactoryGirl.create(:place, lat: 60.04084627, lon: 30.02872467, radius: 1, place_type_id: place_type2.id) }
    let!(:status) { FactoryGirl.create(:status_car, geo_lat: 59.93402709, geo_lon: 30.33640087) }

    it 'should receive' do
      expect(status).to receive(:get_places)
      status.get_places
    end

    it 'return array' do
      statuses = [in_place.id]
      expect(status.get_places).to match_array(statuses)
    end
  end
end
