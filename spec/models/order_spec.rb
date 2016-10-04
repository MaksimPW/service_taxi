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
    let(:car) { FactoryGirl.create(:car) }
    let!(:status1) { FactoryGirl.create(:status_car, car_id: car.id, fixed_time: Time.now - 5.hours) }
    let!(:status2) { FactoryGirl.create(:status_car, car_id: car.id, fixed_time: Time.now - 3.hours) }
    let!(:status3) { FactoryGirl.create(:status_car, car_id: car.id, fixed_time: Time.now - 1.hour) }
    let!(:status_outside) { FactoryGirl.create(:status_car, car_id: car.id, fixed_time: Time.now - 24.hours) }
    let!(:order) { FactoryGirl.create(:order, take_time: Time.now - 6.hours, end_time: Time.now, car_id: car.id) }

    it 'should receive' do
      expect(order).to receive(:define_track)
      order.define_track
    end

    it 'return array StatusCars' do
      statuses = [status1.id, status2.id, status3.id]
      expect(order.define_track).to match_array(statuses)
    end
  end
end