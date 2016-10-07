class OrdersController < ApplicationController
  def index
    @orders = Order.all.order(id: :desc)
  end

  def show
    @order = Order.find(params[:id])
  end
end
