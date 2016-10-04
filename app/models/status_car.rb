class StatusCar < ActiveRecord::Base

  def get_places
    places = Place.all
    @location_types = Array.new
    places.each do |p|
      if Geocoder::Calculations.distance_between([self.geo_lat, self.geo_lon],[p.lat, p.lon]) < p.radius
         @location_types << p.place_type_id
      end
    end
    @location_types
  end
end
