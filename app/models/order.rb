class Order < ActiveRecord::Base
  belongs_to :order_type

  before_save :define_geodata

  def define_track
    o = self
    StatusCar.where{(fixed_time > o.take_time) & (fixed_time < o.end_time) & (car_id = o.car_id)}.pluck(:id)
  end

  # Now: inspection-1
  # TODO: Add more inspections;
  def define_type
    # Define track
    @track_place = Array.new
    @track = self.define_track
    unless @track.empty?
      @track_place[0] = StatusCar.find(@track.first).get_places
      @track_place[1] = StatusCar.find(@track.last).get_places
    end

    # Check order type
    if (@track_place[0].include? 1) && (@track_place[1].include? 4)
      self.order_type_id = 1
    else
      false
    end
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
