require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe 'GET /index' do
    let(:orders) { create_list(:order, 3) }
    before { get :index }

    it 'returns 200 status' do
      expect(response.status).to eq 200
    end

    it 'populates an array of all orders' do
      expect(assigns(:orders)).to match_array(orders)
    end
  end

  describe 'GET /show' do
    let(:order) { create(:order) }
    before { get :show, id: order.id }

    it 'returns 200 status' do
      expect(response.status).to eq 200
    end

    it 'assigns the requested question to @question' do
      expect(assigns(:order)).to eq order
    end
  end
end