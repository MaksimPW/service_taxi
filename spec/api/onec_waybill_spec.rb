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

      let(:user) { FactoryGirl.create(:user) }
      let(:access_token) { FactoryGirl.create(:access_token) }

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
end