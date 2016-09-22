require 'rails_helper'

RSpec.describe Order, type: :model do
  context '.define_geodata' do
    it 'should receive' do
      order = Order.create(begin_address: 'Moscow', end_address: 'St. Petersburg')
      expect(order).to receive(:define_geodata)
      order.save
    end
  end
end