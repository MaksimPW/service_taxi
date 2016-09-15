require 'rails_helper'

RSpec.describe Integration::RadiotaxiController, type: :controller do
  describe 'POST /cars' do
    it 'returns 200 status' do
      post :cars
      expect(response.status).to eq 200
    end

    it 'saves the new Cars in the database' do
      expect { post :cars }.to change(Car, :count).by(3)
    end

    it 'does not create the new Cars after equal id value' do
      post :cars
      expect { post :cars }.to_not change(Car, :count)
    end
  end

  describe 'POST /drivers' do
    it 'returns 200 status' do
      post :drivers
      expect(response.status).to eq 200
    end

    it 'saves the new Drivers in the database' do
      expect { post :drivers }.to change(Driver, :count).by(4)
    end

    it 'does not create the new Drivers after equal id value' do
      post :drivers
      expect { post :drivers }.to_not change(Driver, :count)
    end
  end

  describe 'POST /orders' do
    it 'returns 200 status' do
      post :orders, take_date: '2016-09-13'
      expect(response.status).to eq 200
    end

    it 'saves the new Orders in the database' do
      expect { post :orders, take_date: '2016-09-13' }.to change(Order, :count).by(6)
    end

    it 'does not create the new Orders after equal id value' do
      post :orders
      expect { post :cars, take_date: '2016-09-13' }.to_not change(Order, :count)
    end
  end
end