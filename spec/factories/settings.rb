FactoryGirl.define do
  factory :setting do
    max_diff_between_actual_track 20   # percents
    max_rest_time_after_order 900      # seconds
    max_park_distance_after_order 0.5  # km
    max_rest_time 3600                 # seconds
    max_park_time 25200                # seconds
    max_diff_geo 0.020                 # km
  end
end
