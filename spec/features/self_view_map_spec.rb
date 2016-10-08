require 'rails_helper'

# This test is for self-view
RSpec.feature 'Self-View map' do
  let!(:car) { create(:car) }
  let!(:track) { create(:track) }
  let!(:user) { create(:user) }
  context 'route for 2 waypoints' do
    let!(:order) { create(:order,
                          take_time: Time.now - 6.hours,
                          end_time: Time.now,
                          car_id: car.id,
                          begin_address: 'МО №17 "Шувалово-Озерки", Питер',
                          end_address: 'Северный проспект, 60 к1, Питер',
                          distance: 13) }
    let!(:status1) { create(:status_car,
                            car_id: car.id,
                            geo_lat: order.begin_lat,
                            geo_lon: order.begin_lon,
                            fixed_time: Time.now - 5.hours - 40.minutes) }
    let!(:status2) { create(:status_car,
                            car_id: car.id,
                            geo_lat: order.end_lat,
                            geo_lon: order.end_lon,
                            fixed_time: 25.minutes.ago) }

    scenario 'show order map for self-view' do
      visit order_path(order)
      save_and_open_page
    end

    scenario 'show sample track map for self-view' do
      sign_in(user)
      visit "/admin/track/#{track.id}/map"
      save_and_open_page
    end
  end
end