FactoryGirl.define do
  sequence :waybill_id do |n|
    "#{n}string"
  end

  factory :waybill do
    waybill_id
    waybill_number "MyString"
    car_number "MyString"
    creator ""
    driver_alias "MyString"
    fio "Ivanov Ivan Ivanich"
    created_waybill_at "2016-09-16 07:27:44"
    begin_road_at "2016-09-16 10:00:00"
    end_road_at "2016-09-16 11:00:00"
  end
end
