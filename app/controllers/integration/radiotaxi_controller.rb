class Integration::RadiotaxiController < ApplicationController

  def cars
    Integration::Radiotaxi.load_cars
    render nothing: true
  end

  def drivers
    Integration::Radiotaxi.load_drivers
    render nothing: true
  end

  def orders
    Integration::Radiotaxi.load_orders(params[:take_date])
    render nothing: true
  end
end