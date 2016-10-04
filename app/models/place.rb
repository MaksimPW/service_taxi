class Place < ActiveRecord::Base
  belongs_to :place_type

  geocoded_by :address, :latitude  => :lat, :longitude => :lon
  before_save :geocode, :unless => :address_empty?

  def address_empty?
    address.nil? || address.empty?
  end
end
