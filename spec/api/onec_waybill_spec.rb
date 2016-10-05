require 'rails_helper'

describe 'Waybill API' do
  describe 'GET /ping' do
    context 'unauth' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/api_waybills/ping', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get '/api/v1/api_waybills/ping', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'auth' do
      before { get '/api/v1/api_waybills/ping', format: :json, access_token: access_token.token }

      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(version access).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to have_json_path("#{attr}")
        end
      end
    end
  end

  describe 'POST /create' do
    let(:waybill) { create(:waybill) }

    context 'unauth' do
      it 'returns 401 status if there is no access_token' do
        post '/api/v1/api_waybills', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        post '/api/v1/api_waybills', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'auth' do
      before { post '/api/v1/api_waybills', { format: :json, waybill: attributes_for(:waybill), access_token: access_token.token } }

      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id waybill_number car_number creator driver_alias fio created_waybill_at begin_road_at end_road_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to have_json_path("#{attr}")
        end
      end

      it 'saves the new Waybill in the database' do
        expect { post '/api/v1/api_waybills', { format: :json, waybill: attributes_for(:waybill), access_token: access_token.token } }.to change(Waybill, :count).by(1)
      end
    end
  end

  describe 'PATCH /update' do
    let!(:waybill) { create(:waybill) }
    let(:waybill_updated_fio) { waybill.fio = 'Test Testov Testovich' }

    context 'unauth' do
      it 'returns 401 status if there is no access_token' do
        patch "/api/v1/api_waybills/#{waybill.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        patch "/api/v1/api_waybills/#{waybill.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'auth' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }

      it 'returns 200 status' do
        patch "/api/v1/api_waybills/#{waybill.id}", waybill: attributes_for(:waybill), format: :json, access_token: access_token.token
        expect(response).to be_success
      end

      it 'assigns the requested waybill to waybill' do
        patch "/api/v1/api_waybills/#{waybill.id}", waybill: attributes_for(:waybill), format: :json, access_token: access_token.token
        expect(assigns(:waybill)).to eq waybill
      end

      it 'changes waybill attributes' do
        patch "/api/v1/api_waybills/#{waybill.id}", waybill: { fio: waybill_updated_fio }, format: :json, access_token: access_token.token
        waybill.reload
        expect(waybill.fio).to eq waybill_updated_fio
      end

      it 'does not change record count in the database' do
        expect { patch "/api/v1/api_waybills/#{waybill.id}", id: waybill, waybill: { fio: waybill_updated_fio }, format: :json, access_token: access_token.token }.to_not change(Waybill, :count)
      end

      %w(id waybill_number car_number creator driver_alias fio created_waybill_at begin_road_at end_road_at).each do |attr|
        it "contains #{attr}" do
          patch "/api/v1/api_waybills/#{waybill.id}", waybill: { fio: waybill_updated_fio }, format: :json, access_token: access_token.token
          expect(response.body).to have_json_path("#{attr}")
        end
      end
    end
  end
end