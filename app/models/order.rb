class Order < ActiveRecord::Base
  belongs_to :order_type

  before_save :define_geodata

  def define_track
    o = self
    StatusCar.where{(fixed_time > o.take_time) & (fixed_time < o.end_time) & (car_id = o.car_id)}.pluck(:id)
  end

  # TODO: Add more inspections
  # List:
  # inspection-1
  # inspection-2

  def define_type
    # Define track
    @track_place = Array.new
    @track = self.define_track

    unless @track.empty?
      track_first = StatusCar.find(@track.first)
      track_last = StatusCar.find(@track.last)

      # Check location in places
      @track_place[0] = track_first.get_places
      @track_place[1] = track_last.get_places

      # Check location nearby with order begin/end addresses
      [track_first, track_last].each_with_index do |location, index|
        if Geocoder::Calculations.distance_between([location.geo_lat, location.geo_lon],
                                                   [self.begin_lat, self.begin_lon],
                                                   units: :km) <= Setting.first.max_park_distance_after_order
          @track_place[index] << 'begin_address'
        end

        if Geocoder::Calculations.distance_between([location.geo_lat, location.geo_lon],
                                                   [self.end_lat, self.end_lon],
                                                   units: :km) <= Setting.first.max_park_distance_after_order
          @track_place[index] << 'end_address'
        end
      end
    end

    # Check order type
    if (@track_place[0].include? 1) && (@track_place[1].include? 4)
      self.order_type_id = 1
    elsif (@track_place[0].include? 4) && (@track_place[1].include? 'begin_address')
      self.order_type_id = 2
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
