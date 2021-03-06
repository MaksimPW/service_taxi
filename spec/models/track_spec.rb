require 'rails_helper'

RSpec.describe Track, type: :model do
  it { should belong_to(:track_type) }
  it { should belong_to(:order) }
  it { should belong_to(:car) }
  it { should have_many(:status_cars) }

  context '.get_time_track' do
    let!(:status1) { create(:status_car, fixed_time: '2016-10-10 10:05:00') }
    let!(:status2) { create(:status_car, fixed_time: '2016-10-10 10:10:00') }
    let!(:status3) { create(:status_car, fixed_time: '2016-10-10 10:15:00') }
    let!(:status4) { create(:status_car, fixed_time: '2016-10-10 10:20:00') }
    let!(:status5) { create(:status_car, fixed_time: '2016-10-10 10:25:00') }
    let!(:status6) { create(:status_car, fixed_time: '2016-10-10 10:30:00') }

    let!(:statuses) { [status1, status2, status3, status4, status5, status6] }

    it 'should receive' do
      expect(Track).to receive(:get_time_track).with(statuses)
      Track.get_time_track(statuses)
    end

    it 'return time in seconds' do
      expect(Track.get_time_track(statuses)).to eq 1500
    end
  end

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
      let(:max_speed) { Setting.first.max_stay_speed + 1 }
      let(:min_speed) { Setting.first.max_stay_speed - 1 }
      let!(:order) { create(:order,
                            take_time: '2016-10-09 12:00:00',
                            end_time: '2016-10-09 13:00:00',
                            begin_lat: 59.97228119,
                            begin_lon: 30.51867306,
                            car_id: car.id) }
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
                                  car_id: car.id,
                                  speed: max_speed) }
      let!(:status_wait_place) { create(:status_car,
                                        fixed_time: '2016-10-09 11:00:00',
                                        geo_lat: wait_place.lat,
                                        geo_lon: wait_place.lon,
                                        car_id: car.id,
                                        speed: max_speed) }
      let!(:status_track1_end) { create(:status_car,
                                        fixed_time: '2016-10-09 11:50:00',
                                        geo_lat: 59.97274828,
                                        geo_lon: 30.52033603,
                                        car_id: car.id,
                                        speed: max_speed) }
      let!(:status_order_begin) { create(:status_car,
                                         fixed_time: '2016-10-09 12:10:00',
                                         geo_lat: order.begin_lat,
                                         geo_lon: order.begin_lon,
                                         car_id: car.id,
                                         speed: max_speed) }
      let!(:status_order_end) { create(:status_car,
                                       fixed_time: '2016-10-09 12:50:00',
                                       car_id: car.id,
                                       speed: max_speed) }

      it 'expected return 7' do
        car.define_tracks('2016-10-09 10:00:00','2016-10-09 14:00:00')
        track = Track.all[0]
        track.define_type
        expect(track.track_type_id).to eq 7
      end
    end

    context 'inspection-8 | Ожидание между заказами' do
      context 'Ожидание рядом с последним заказом' do
        let!(:settings) { create(:setting, max_park_distance_after_order: 0.5, max_rest_time_after_order: 900) }

        let(:max_speed) { Setting.first.max_stay_speed + 1 }
        let(:min_speed) { Setting.first.max_stay_speed - 1 }

        let!(:prev_order) { create(:order,
                                   take_time: '2016-10-09 10:00:00',
                                   end_time: '2016-10-09 12:00:00',
                                   end_lat: '59.9342802',
                                   end_lon: '30.3350986',
                                   car_id: car.id) }
        let!(:next_order) { create(:order,
                                   take_time: '2016-10-09 17:00:00',
                                   end_time: '2016-10-09 18:00:00',
                                   car_id: car.id) }
        let!(:status_active1) { create(:status_car, fixed_time: '2016-10-09 12:10:00', geo_lat: '59.93375295', geo_lon: '30.33825159', car_id: car.id, speed: max_speed) }
        let!(:status_stay1) { create(:status_car, fixed_time: '2016-10-09 12:15:00', geo_lat: '59.93377445', geo_lon: '30.33919573', car_id: car.id, speed: min_speed) }
        let!(:status_stay2) { create(:status_car, fixed_time: '2016-10-09 12:17:00', geo_lat: '59.93377445', geo_lon: '30.33919573', car_id: car.id, speed: min_speed) }
        let!(:status_stay3) { create(:status_car, fixed_time: '2016-10-09 12:20:00', geo_lat: '59.93377445', geo_lon: '30.33919573', car_id: car.id, speed: min_speed) }
        let!(:status_stay4) { create(:status_car, fixed_time: '2016-10-09 12:23:00', geo_lat: '59.93377445', geo_lon: '30.33919573', car_id: car.id, speed: min_speed) }
        let!(:status_active2) { create(:status_car, fixed_time: '2016-10-09 12:40:00', car_id: car.id, speed: max_speed) }
        let!(:status_active3) { create(:status_car, fixed_time: '2016-10-09 12:50:00', car_id: car.id, speed: max_speed) }
        let!(:status_active4) { create(:status_car, fixed_time: '2016-10-09 13:00:00', car_id: car.id, speed: max_speed) }
        let!(:status_active5) { create(:status_car, fixed_time: '2016-10-09 13:10:00', car_id: car.id, speed: max_speed) }
        let!(:status_active6) { create(:status_car, fixed_time: '2016-10-09 13:20:00', car_id: car.id, speed: max_speed) }
        let!(:status_active7) { create(:status_car, fixed_time: '2016-10-09 13:30:00', car_id: car.id, speed: max_speed) }

        it 'expected return 8' do
          car.define_tracks('2016-10-09 10:00:00','2016-10-09 14:00:00')
          track = Track.all[0]
          track.define_type
          expect(track.track_type_id).to eq 8
        end
      end
    end

    context 'inspection-9 | Поездка на отдых' do
      let(:settings) { create(:setting, max_rest_time: 3600) }

      let(:max_speed) { Setting.first.max_stay_speed + 1 }
      let(:min_speed) { Setting.first.max_stay_speed - 1 }

      let!(:track) { create(:track, car_id: car.id) }
      let!(:park_place) { create(:place, lat: 60.01588292, lon: 30.58512479, radius: 2, place_type_id: 1) }
      let!(:active1) { create(:status_car, fixed_time: '2016-10-09 10:00:00', car_id: car.id, speed: max_speed, track_id: track.id) }
      let!(:active2) { create(:status_car, fixed_time: '2016-10-09 11:00:00', car_id: car.id, speed: max_speed, track_id: track.id) }
      let!(:stay1) { create(:status_car, fixed_time: '2016-10-09 11:05:00', geo_lat: 60.01588292, geo_lon: 30.58512479, car_id: car.id, speed: min_speed, track_id: track.id) }
      let!(:stay2) { create(:status_car, fixed_time: '2016-10-09 11:12:00', geo_lat: 60.01588292, geo_lon: 30.58512479, car_id: car.id, speed: min_speed, track_id: track.id) }
      let!(:stay3) { create(:status_car, fixed_time: '2016-10-09 11:40:00', geo_lat: 60.01588292, geo_lon: 30.58512479, car_id: car.id, speed: min_speed, track_id: track.id) }
      let!(:stay4) { create(:status_car, fixed_time: '2016-10-09 12:00:00', geo_lat: 60.01588292, geo_lon: 30.58512479, car_id: car.id, speed: min_speed, track_id: track.id) }
      let!(:active3) { create(:status_car, fixed_time: '2016-10-09 12:20:00', car_id: car.id, speed: max_speed) }

      it 'expected return 9' do
        track.define_type
        expect(track.track_type_id).to eq 9
      end
    end

    context 'inspection-10 | Поездка через АЗС' do
      let(:track) { create(:track, car_id: car.id)}
      let!(:gas_place) { create(:place, lat: 60.01588292, lon: 60.01588292, radius: 2, place_type_id: 3) }
      let!(:status1) { create(:status_car, fixed_time: '2016-10-09 10:00:00', car_id: car.id, track_id: track.id) }
      let!(:status2) { create(:status_car, fixed_time: '2016-10-09 11:00:00', geo_lat: 60.01588292, geo_lon: 60.01588292, car_id: car.id, track_id: track.id) }
      let!(:status3) { create(:status_car, fixed_time: '2016-10-09 12:00:00', car_id: car.id, track_id: track.id) }

      it 'expected return 10' do
        track.define_type
        expect(track.track_type_id).to eq 10
      end
    end

    context 'inspection-11 | Стоянка' do
      let(:settings) { create(:setting, max_park_time: 25200) }

      let(:min_speed) { Setting.first.max_stay_speed - 1 }

      let(:track) { create(:track, car_id: car.id)}
      let!(:status1) { create(:status_car, fixed_time: '2016-10-09 11:00:00', car_id: car.id, track_id: track.id, speed: min_speed) }
      let!(:status2) { create(:status_car, fixed_time: '2016-10-09 15:00:00', geo_lat: 60.01588292, geo_lon: 60.01588292, car_id: car.id, track_id: track.id, speed: min_speed) }
      let!(:status3) { create(:status_car, fixed_time: '2016-10-09 18:00:00', car_id: car.id, track_id: track.id, speed: min_speed) }

      it 'expected return 11' do
        track.define_type
        expect(track.track_type_id).to eq 11
      end
    end

    context 'inspection-12 | Исчерпан лимит стоянки' do
      let(:settings) { create(:setting, max_park_time: 25200) }

      let(:min_speed) { Setting.first.max_stay_speed - 1 }

      let(:track) { create(:track, car_id: car.id)}
      let!(:status1) { create(:status_car, fixed_time: '2016-10-09 9:00:00', car_id: car.id, track_id: track.id, speed: min_speed) }
      let!(:status2) { create(:status_car, fixed_time: '2016-10-09 15:00:00', geo_lat: 60.01588292, geo_lon: 60.01588292, car_id: car.id, track_id: track.id, speed: min_speed) }
      let!(:status3) { create(:status_car, fixed_time: '2016-10-09 18:00:00', car_id: car.id, track_id: track.id, speed: min_speed) }

      it 'expected return 12' do
        track.define_type
        expect(track.track_type_id).to eq 12
      end
    end

    context 'inspection-13 | Поездка в парк' do
      let(:max_speed) { Setting.first.max_stay_speed + 1 }
      let(:min_speed) { Setting.first.max_stay_speed - 1 }
      let!(:park_place) { create(:place, lat: 59.93093, lon: 30.36157, radius: 2, place_type_id: 1) }
      let!(:first_order) { create(:order, take_time: '2016-10-09 12:00:00', end_time: '2016-10-09 13:00:00', car_id: car.id) }
      let!(:last_order) { create(:order,
                            take_time: '2016-10-09 14:00:00',
                            end_time: '2016-10-09 15:00:00',
                            end_lat: 59.97228119,
                            end_lon: 30.51867306,
                            car_id: car.id) }
      let!(:status_first_order1) { create(:status_car, fixed_time: '2016-10-09 12:10:00', car_id: car.id, speed: max_speed, track_id: track.id) }
      let!(:status_first_order2) { create(:status_car, fixed_time: '2016-10-09 12:50:00', car_id: car.id, speed: max_speed, track_id: track.id) }
      let!(:status_between) { create(:status_car, fixed_time: '2016-10-09 13:30:00', car_id: car.id, speed: max_speed, track_id: track.id) }
      let!(:status_last_order1) { create(:status_car, fixed_time: '2016-10-09 14:10:00', car_id: car.id, speed: max_speed, track_id: track.id) }
      let!(:status_last_order2) { create(:status_car, fixed_time: '2016-10-09 14:50:00', car_id: car.id, speed: max_speed, track_id: track.id) }
      let!(:status_last1) { create(:status_car, fixed_time: '2016-10-09 15:10:00', car_id: car.id, speed: max_speed, track_id: track.id, geo_lat: last_order.end_lat, geo_lon: last_order.end_lon) }
      let!(:status_last2) { create(:status_car, fixed_time: '2016-10-09 16:00:00', car_id: car.id, speed: max_speed, track_id: track.id, geo_lat: park_place.lat, geo_lon: park_place.lon) }

      it 'expect return 13' do
        car.define_tracks('2016-10-09 10:00:00','2016-10-09 17:00:00')
        track = Track.last
        track.define_type
        expect(track.track_type_id).to eq 13
      end
    end
  end
end
