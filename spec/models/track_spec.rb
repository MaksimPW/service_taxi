require 'rails_helper'

RSpec.describe Track, type: :model do
  it { should belong_to(:track_type) }
  it { should belong_to(:order) }
  it { should belong_to(:car) }
  it { should have_many(:status_cars) }

  context '#define_type' do
    let!(:setting) { create(:setting) }
    let(:car) { create(:car) }
    let(:track) { create(:track, car_id: car) }

    it 'should receive' do
      expect(track).to receive(:define_type)
      track.define_type
    end

    context 'inspection-5 | Данных мало или они отсутствуют' do
      it 'expected return 5' do
        track.define_type
        expect(track.track_type_id).to eq 5
      end
    end

    context 'with order' do
      context 'inspection-4 | Превышен лимит по дистанции' do
        let!(:order) { create(:order,
                              take_time: '2016-10-09 12:00:00',
                              end_time: '2016-10-09 13:00:00',
                              car_id: car.id,
                              begin_address: 'МО №17 "Шувалово-Озерки", Питер',
                              end_address: 'Северный проспект, 60 к1, Питер') }
        #let!(:track) { create(:track, car_id: car, order_id: order) }
        let!(:status1) { create(:status_car,
                                car_id: car.id,
                                geo_lat: order.begin_lat,
                                geo_lon: order.begin_lon,
                                fixed_time: '2016-10-09 12:10:00') }
        let!(:status2) { create(:status_car,
                                car_id: car.id,
                                geo_lat: 60.1255121,
                                geo_lon: 30.3888101,
                                fixed_time: '2016-10-09 12:30:00') }
        let!(:status3) { create(:status_car,
                                car_id: car.id,
                                geo_lat: order.end_lat,
                                geo_lon: order.end_lon,
                                fixed_time: '2016-10-09 12:50:00') }

        it 'expected return 4' do
          car.define_tracks('2016-10-09 11:00:00','2016-10-09 14:00:00')
          track = Track.all[0]
          track.define_type
          expect(track.track_type_id).to eq 4
        end
      end

      context 'inspection-3 | Поездка по заказу' do
        let!(:order) { create(:order,
                              take_time: '2016-10-09 12:00:00',
                              end_time: '2016-10-09 13:00:00',
                              car_id: car.id,
                              begin_address: 'МО №17 "Шувалово-Озерки", Питер',
                              end_address: 'Северный проспект, 60 к1, Питер',
                              distance: 13) }
        let!(:status1) { create(:status_car,
                                car_id: car.id,
                                geo_lat: order.begin_lat,
                                geo_lon: order.begin_lon,
                                fixed_time: '2016-10-09 12:10:00') }
        let!(:status2) { create(:status_car,
                                car_id: car.id,
                                geo_lat: order.end_lat,
                                geo_lon: order.end_lon,
                                fixed_time: '2016-10-09 12:50:00') }

        it 'expected return 3' do
          car.define_tracks('2016-10-09 11:00:00','2016-10-09 14:00:00')
          track = Track.all[0]
          track.define_type
          expect(track.track_type_id).to eq 3
        end
      end
    end
  end
end
