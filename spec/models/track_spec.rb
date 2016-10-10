require 'rails_helper'

RSpec.describe Track, type: :model do
  it { should belong_to(:track_type) }
  it { should belong_to(:order) }
  it { should belong_to(:car) }
  it { should have_many(:status_cars) }

  context '#get_stay_tracks' do
    let(:max_speed) { Setting.first.max_stay_speed + 1 }
    let(:min_speed) { Setting.first.max_stay_speed - 1}

    let!(:setting) { create(:setting) }
    let!(:car) { create(:car) }
    let!(:track) { create(:track, car_id: car.id) }
    let!(:motion1) { create(:status_car, speed: max_speed, car_id: car.id, track_id: track.id, fixed_time: '2016-10-10 10:00:00') }
    let!(:stay1) { create(:status_car, speed: min_speed, car_id: car.id, track_id: track.id, fixed_time: '2016-10-10 10:05:00') }
    let!(:stay2) { create(:status_car, speed: min_speed, car_id: car.id, track_id: track.id, fixed_time: '2016-10-10 10:10:00') }
    let!(:stay3) { create(:status_car, speed: min_speed, car_id: car.id, track_id: track.id, fixed_time: '2016-10-10 10:15:00') }
    let!(:stay4) { create(:status_car, speed: min_speed, car_id: car.id, track_id: track.id, fixed_time: '2016-10-10 10:20:00') }
    let!(:stay5) { create(:status_car, speed: min_speed, car_id: car.id, track_id: track.id, fixed_time: '2016-10-10 10:25:00') }
    let!(:stay6) { create(:status_car, speed: min_speed, car_id: car.id, track_id: track.id, fixed_time: '2016-10-10 10:30:00') }
    let!(:motion2) { create(:status_car, speed: max_speed, car_id: car.id, track_id: track.id, fixed_time: '2016-10-10 10:35:00') }
    let!(:motion3) { create(:status_car, speed: max_speed, car_id: car.id, track_id: track.id, fixed_time: '2016-10-10 10:40:00') }
    let!(:motion4) { create(:status_car, speed: max_speed, car_id: car.id, track_id: track.id, fixed_time: '2016-10-10 10:45:00') }
    let!(:stay7) { create(:status_car, speed: min_speed, car_id: car.id, track_id: track.id, fixed_time: '2016-10-10 10:50:00') }
    let!(:stay8) { create(:status_car, speed: min_speed, car_id: car.id, track_id: track.id, fixed_time: '2016-10-10 10:55:00') }
    let!(:stay9) { create(:status_car, speed: min_speed, car_id: car.id, track_id: track.id, fixed_time: '2016-10-10 11:00:00') }

    it 'should receive' do
      expect(track).to receive(:get_stay_tracks)
      track.get_stay_tracks
    end

    it 'Track.status_cars should eq StatusCar' do
      expect(track.status_cars).to eq StatusCar.all
    end

    it 'return 2 stay tracks' do
      expect(track.get_stay_tracks.count).to eq 2
    end

    it 'First stay track count eq 6' do
      expect(track.get_stay_tracks[0].count).to eq 6
    end

    it 'Last stay track count eq 3' do
      expect(track.get_stay_tracks[1].count).to eq 3
    end
  end

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

    context 'inspection-7 | Поездка из парка до места ожидания первого заказа, а дальше от места ожидания первого заказа к месту подачи' do
      let!(:order) { create(:order,
                            take_time: '2016-10-09 12:00:00',
                            end_time: '2016-10-09 13:00:00',
                            begin_lat: 59.97228119,
                            begin_lon: 30.51867306,
                            car_id: car.id)}
      let!(:park_place) { create(:place,
                                 lat: 60.01588292,
                                 lon: 30.58512479,
                                 radius: 2,
                                 place_type_id: 1) }
      let!(:wait_place) { create(:place,
                                 lat: 59.98164325,
                                 lon: 30.51138282,
                                 radius: 1,
                                 place_type_id: 4) }
      let!(:status_park) { create(:status_car,
                                  fixed_time: '2016-10-09 10:10:00',
                                  geo_lat: park_place.lat,
                                  geo_lon: park_place.lon,
                                  car_id: car.id) }
      let!(:status_wait_place) { create(:status_car,
                                        fixed_time: '2016-10-09 11:00:00',
                                        geo_lat: wait_place.lat,
                                        geo_lon: wait_place.lon,
                                        car_id: car.id) }
      let!(:status_track1_end) { create(:status_car,
                                        fixed_time: '2016-10-09 11:50:00',
                                        geo_lat: 59.97274828,
                                        geo_lon: 30.52033603,
                                        car_id: car.id) }
      let!(:status_order_begin) { create(:status_car,
                                         fixed_time: '2016-10-09 12:10:00',
                                         geo_lat: order.begin_lat,
                                         geo_lon: order.begin_lon,
                                         car_id: car.id) }
      let!(:status_order_end) { create(:status_car,
                                       fixed_time: '2016-10-09 12:50:00',
                                       car_id: car.id) }

      it 'expected return 7' do
        car.define_tracks('2016-10-09 10:00:00','2016-10-09 14:00:00')
        track = Track.all[0]
        track.define_type
        expect(track.track_type_id).to eq 7
      end
    end
  end
end
