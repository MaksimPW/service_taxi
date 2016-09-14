FactoryGirl.define do
  factory :order do
    car ""
    driver ""
    status_buy ""
    operator "MyString"
    take_time "2016-09-14 11:54:50"
    begin_time "2016-09-14 11:54:50"
    end_time "2016-09-14 11:54:50"
    begin_address_name "MyString"
    end_address_name "MyString"
    begin_geo "MyString"
    end_geo "MyString"
    cost 1.5
    distance 1.5
    description "MyText"
  end
end
