class Order < ActiveRecord::Base
  belongs_to :order_type

  before_save :define_geodata

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
