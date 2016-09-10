require 'rails_helper'

RSpec.describe Integration::GeoritmController, type: :controller do
  describe 'GET /ping' do
    before { get :ping }

    it 'returns 200 status' do
      expect(response.status).to eq 200
    end

    %w(success version buildTs).each do |attr|
      it "contains #{attr}" do
        expect(response.body).to have_json_path(attr)
      end
    end
  end

  describe 'GET /init' do
    before { get :init }

    it 'returns success status' do
      expect(response.status).to eq 200
    end

    %w(id username basic isAdmin).each do |attr|
      it "contains #{attr}" do
        expect(response.body).to have_json_path(attr)
      end
    end

    %w(msg hdr data).each do |attr|
      it "does not contains #{attr}" do
        expect(response.body).to_not have_json_path(attr)
      end
    end
  end

  describe 'POST /execute' do
    context 'auth' do
      before do
        get :init
        post :execute
      end

      %w(id rev speed lat lon licenseNumber name model).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to have_json_path("0/#{attr}")
        end
      end

      it 'saves the new StatusCars in the database' do
        expect { post :execute }.to change(StatusCar, :count)
      end
    end

    context 'unauth' do
      %w(id rev speed lat lon licenseNumber name model).each do |attr|
        it "contains #{attr}" do
          post :execute
          expect(response.body).to_not have_json_path("0/#{attr}")
        end
      end

      it 'does not save StatusCars' do
        expect { post :execute }.to_not change(StatusCar, :count)
      end
    end
  end
end