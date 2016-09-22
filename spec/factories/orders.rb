FactoryGirl.define do
  factory :order do
    car_id ""
    driver_id ""
    status_buy ""
    operator "MyString"
    take_time "2016-09-14 11:54:50"
    begin_time "2016-09-14 11:54:50"
    end_time "2016-09-14 11:54:50"
    begin_address "MyString"
    end_address "MyString"
    begin_lon ""
    begin_lat ""
    end_lon ""
    end_lat ""
    cost 1.5
    distance 1.5
    description "MyText"
  end
end
