class Place < ActiveRecord::Base
  belongs_to :place_type

  geocoded_by :address, :latitude  => :lat, :longitude => :lon
  after_save :geocode, :unless => :address_empty?

  def address_empty?
    address.empty?
  end
end
