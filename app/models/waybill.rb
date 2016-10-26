class Waybill < ActiveRecord::Base
  self.primary_key = 'id'

  after_create :convert_car_number

  def convert_car_number
    self.car_number = self.car_number.mb_chars.upcase.to_s.tr(' ','-')
    self.save
  end
end
