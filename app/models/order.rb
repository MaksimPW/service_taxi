class Order < ActiveRecord::Base
  belongs_to :order_type

  before_save :define_geodata

  def define_track
    o = self
    StatusCar.where{(fixed_time > o.take_time) & (fixed_time < o.end_time) & (car_id = o.car_id)}.pluck(:id)
  end

  private

  def define_geodata
    if begin_address_changed?
      geocoded = Geocoder.search(begin_address).first
      if geocoded
        self.begin_lat = geocoded.latitude
        self.begin_lon = geocoded.longitude
      end
    end
    if end_address_changed?
      geocoded = Geocoder.search(end_address).first
      if geocoded
        self.end_lat = geocoded.latitude
        self.end_lon = geocoded.longitude
      end
    end
  end
end
