require 'rails_helper'

# This test is for self-view
RSpec.feature 'Self-View map' do
  let!(:car) { create(:car) }
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
  end

  context 'route map for tracks' do
    let(:track) { create(:track, begin_time: '2016-10-09', end_time: '2016-11-09', car_id: car.id)}
    let!(:status1) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 07:20:00', track_id: track.id, geo_lat: 59.95569783, geo_lon: 30.46440125) }
    let!(:status2) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 07:30:00', track_id: track.id, geo_lat: 59.96136976, geo_lon: 30.48688889) }
    let!(:status3) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 07:40:00', track_id: track.id, geo_lat: 59.96772804, geo_lon: 30.50336838) }
    let!(:status4) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 07:50:00', track_id: track.id, geo_lat: 59.97700549, geo_lon: 30.5006218) }
    let!(:status5) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 08:00:00', track_id: track.id, geo_lat: 59.98061269, geo_lon: 30.5188179) }
    let!(:status6) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 08:10:00', track_id: track.id, geo_lat: 59.97116443, geo_lon: 30.54791451) }
    let!(:status7) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 08:20:00', track_id: track.id, geo_lat: 59.95767452, geo_lon: 30.55186272) }
    let!(:status8) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 08:30:00', track_id: track.id, geo_lat: 59.94589859, geo_lon: 30.54156303) }
    let!(:status9) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 08:40:00', track_id: track.id, geo_lat: 59.94546873, geo_lon: 30.52079201) }
    let!(:status10) { create(:status_car, car_id: car.id, fixed_time: '2016-10-08 08:50:00', track_id: track.id, geo_lat: 59.93575245, geo_lon: 30.52044868) }
    scenario 'show sample track map for self-view' do
      sign_in(user)
      visit "/admin/track/#{track.id}/map"
      save_and_open_page
    end
  end
end