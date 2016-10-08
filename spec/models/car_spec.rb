require 'rails_helper'

RSpec.describe Car, type: :model do
  it { should have_many(:orders) }
  it { should have_many(:status_cars) }
  it { should have_many(:tracks) }

  context '#define_tracks' do
    let!(:car) { create(:car) }
    let!(:order1) { create(:order, car_id: car.id, take_time: '2016-10-08 06:00:00', end_time: '2016-10-08 07:10:00') }
    let!(:order2) { create(:order, car_id: car.id, take_time: '2016-10-08 09:50:00', end_time: '2016-10-08 11:10:00') }

    let!(:status1) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 05:00:00') }
    let!(:status2) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 05:10:00') }
    let!(:status3) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 05:20:00') }
    let!(:status4) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 05:30:00') }
    let!(:status5) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 05:40:00') }
    let!(:status6) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 05:50:00') }
    # Order begin
    let!(:status7) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 06:00:00') }
    let!(:status8) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 06:10:00') }
    let!(:status9) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 06:20:00') }
    let!(:status10) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 06:30:00') }
    let!(:status11) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 06:40:00') }
    let!(:status12) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 06:50:00') }
    let!(:status13) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 07:00:00') }
    let!(:status14) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 07:10:00') }
    # Order end
    let!(:status15) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 07:20:00') }
    let!(:status16) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 07:30:00') }
    let!(:status17) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 07:40:00') }
    let!(:status18) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 07:50:00') }
    let!(:status19) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 08:00:00') }
    let!(:status20) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 08:10:00') }
    let!(:status21) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 08:20:00') }
    let!(:status22) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 08:30:00') }
    let!(:status23) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 08:40:00') }
    let!(:status24) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 08:50:00') }
    let!(:status25) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 09:00:00') }
    let!(:status26) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 09:10:00') }
    let!(:status27) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 09:20:00') }
    let!(:status28) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 09:30:00') }
    let!(:status29) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 09:40:00') }
    # Order begin
    let!(:status30) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 09:50:00') }
    let!(:status31) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 10:00:00') }
    let!(:status26) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 10:10:00') }
    let!(:status27) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 10:20:00') }
    let!(:status28) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 10:30:00') }
    let!(:status29) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 10:40:00') }
    let!(:status30) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 10:50:00') }
    let!(:status31) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 11:00:00') }
    let!(:status26) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 11:10:00') }
    # Order end
    let!(:status27) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 11:20:00') }
    let!(:status28) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 11:30:00') }
    let!(:status29) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 11:40:00') }
    let!(:status30) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 11:50:00') }
    let!(:status31) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 12:00:00') }

    it 'should receive' do
      expect(car).to receive(:define_tracks).with('2016-10-08 04:30:00' ,'2016-11-08 04:30:00')
      car.define_tracks('2016-10-08 04:30:00' ,'2016-11-08 04:30:00')
    end

    it 'change record count for track' do
      expect { car.define_tracks('2016-10-08 04:30:00' ,'2016-11-08 04:30:00') }.to change(Track, :count).by(5)
    end

    it 'set order.id for track in time order' do
      tracks = Track.where.not(order: nil)
      expect(tracks.count).to eq 2
    end
  end
end
