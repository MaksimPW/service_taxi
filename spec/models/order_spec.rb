require 'rails_helper'

RSpec.describe Order, type: :model do
  context '#define_geodata' do
    it 'should receive' do
      order = Order.create(begin_address: 'Moscow', end_address: 'St. Petersburg')
      expect(order).to receive(:define_geodata)
      order.save
    end
  end

  context '#define_track' do
    let(:car) { create(:car) }
    let!(:status1) { create(:status_car, car_id: car.id, fixed_time: Time.now - 5.hours) }
    let!(:status2) { create(:status_car, car_id: car.id, fixed_time: Time.now - 3.hours) }
    let!(:status3) { create(:status_car, car_id: car.id, fixed_time: Time.now - 1.hour) }
    let!(:status_outside) { create(:status_car, car_id: car.id, fixed_time: Time.now - 24.hours) }
    let!(:order) { create(:order, take_time: Time.now - 6.hours, end_time: Time.now, car_id: car.id) }

    it 'should receive' do
      expect(order).to receive(:define_track)
      order.define_track
    end

    it 'return array StatusCars' do
      statuses = [status1.id, status2.id, status3.id]
      expect(order.define_track).to match_array(statuses)
    end
  end

  context '#define_type' do
    let!(:setting) { create(:setting) }
    let(:car) { create(:car) }
    let(:order) { create(:order, take_time: Time.now - 5.hours, end_time: Time.now, car_id: car.id) }

    it 'should receive' do
      expect(order).to receive(:define_type)
      order.define_type
    end

    context 'inspection-1 | Поездка из парка до места ожидания первого заказа' do
      let!(:order) { create(:order,
                            take_time: Time.now - 5.hours,
                            end_time: Time.now,
                            car_id: car.id,
                            begin_address: 'Репищева, 20 лит А, Питер',
                            end_address: 'Метро Московская, Питер',
                            distance: 23.575) }
      let!(:park_place) { create(:place, place_type_id: 1, address: 'Репищева, 20 лит А, Питер', lon: nil, lat: nil, radius: 1) }
      let!(:wait_place) { create(:place, place_type_id: 4, address: 'Пулковское шоссе, 43 к1, Питер', lon: nil, lat: nil, radius: 1) }
      let!(:status1) { create(:status_car,
                              car_id: car.id,
                              geo_lat: park_place.lat,
                              geo_lon: park_place.lon,
                              fixed_time: Time.now - 4.hours - 50.minutes) }
      let!(:status2) { create(:status_car,
                              car_id: car.id,
                              geo_lat: wait_place.lat,
                              geo_lon: wait_place.lon,
                              fixed_time: Time.now - 20.minutes) }

      it 'return 1' do
        order.define_type
        expect(order.order_type_id).to eq 1
      end
    end

    context 'inspection-2 | Поездка от ожидания заказа к месту подачи' do
      let!(:wait_place) { create(:place, place_type_id: 4, address: 'Пулковское шоссе, 43 к1, Питер', radius: 1) }
      let!(:order) { create(:order,
                            car_id: car.id,
                            take_time: 5.hours.ago,
                            end_time: 1.hour.ago,
                            begin_address: 'Московская, Питер, город Санкт-Петербург, Россия',
                            distance: 1.5) }
      let!(:status1) { create(:status_car,
                              car_id: car.id,
                              geo_lat: wait_place.lat,
                              geo_lon: wait_place.lon,
                              fixed_time: Time.now - 4.hours - 50.minutes ) }
      let!(:status2) { create(:status_car,
                              car_id: car.id,
                              geo_lat: order.begin_lat,
                              geo_lon: order.begin_lon,
                              fixed_time: Time.now - 1.hour - 10.minutes ) }

      it 'return 2' do
        order.define_type
        expect(order.order_type_id).to eq 2
      end
    end

    context 'inspection-3 | Поездка по заказу' do
      let!(:order) { create(:order,
                            take_time: Time.now - 6.hours,
                            end_time: Time.now,
                            car_id: car.id,
                            begin_address: 'МО №17 "Шувалово-Озерки", Питер',
                            end_address: 'Северный проспект, 60 к1, Питер',
                            distance: 13) }
      let!(:status1) { create(:status_car,
                              car_id: car.id,
                              geo_lat: order.begin_lat,
                              geo_lon: order.begin_lon,
                              fixed_time: Time.now - 5.hours - 40.minutes) }
      let!(:status2) { create(:status_car,
                              car_id: car.id,
                              geo_lat: order.end_lat,
                              geo_lon: order.end_lon,
                              fixed_time: 25.minutes.ago) }

      it 'return 3' do
        order.define_type
        expect(order.order_type_id).to eq 3
      end
    end

    context 'inspection-4 | inspection for distance' do
      let!(:order) { create(:order,
                            take_time: Time.now - 6.hours,
                            end_time: Time.now,
                            car_id: car.id,
                            begin_address: 'МО №17 "Шувалово-Озерки", Питер',
                            end_address: 'Северный проспект, 60 к1, Питер') }
      let!(:status1) { create(:status_car,
                              car_id: car.id,
                              geo_lat: order.begin_lat,
                              geo_lon: order.begin_lon,
                              fixed_time: Time.now - 5.hours - 40.minutes) }
      let!(:status2) { create(:status_car,
                              car_id: car.id,
                              geo_lat: 60.1255121,
                              geo_lon: 30.3888101,
                              fixed_time: 2.hours.ago) }
      let!(:status3) { create(:status_car,
                              car_id: car.id,
                              geo_lat: order.end_lat,
                              geo_lon: order.end_lon,
                              fixed_time: 25.minutes.ago) }

      it 'return 4' do
        order.define_type
        expect(order.order_type_id).to eq 4
      end
    end

    context 'inspection-5 | track one' do
      it 'return 5' do
        order.define_type
        expect(order.order_type_id).to eq 5
      end
    end
  end
end