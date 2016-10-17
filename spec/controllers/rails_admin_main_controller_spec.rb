require 'rails_helper'

describe RailsAdmin::MainController, :type => :controller do

  describe 'GET /map' do
    let(:track) { create(:track) }

    before do
      @routes = RailsAdmin::Engine.routes
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in FactoryGirl.create(:user)
    end

    it 'returns 200 status' do
      get :map, model_name: 'Track', id: track.id
      expect(response.status).to eq 200
    end
  end
end