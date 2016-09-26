FactoryGirl.define do
  factory :setting do
    max_diff_between_actual_track 1.5
    max_rest_time_after_order 1
    max_park_distance_after_order 1
    max_rest_time 1
    max_park_time 1
    max_diff_geo 1.5
  end
end
