class Order < ActiveRecord::Base
  belongs_to :track_type
  belongs_to :car
  belongs_to :driver
  has_one :track

  # TODO: Рабозбраться с данными в поле адрес и добавить обработку обратно:
  # before_save :define_geodata

  def define_track
    StatusCar.where(car_id: self.car_id).where(fixed_time: self.take_time..self.end_time).pluck(:id)
  end

  def define_type
    # Define track
    @track_place = Array.new
    @track = self.define_track

    if @track.empty? || @track.count == 1
      return self.track_type_id = 5
    else
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

    @actual_distance = Inspection.summary_build_route(@track)["length"]
    if @actual_distance > self.distance
        different_percent = (100 - self.distance.to_f/@actual_distance.to_f*100)
        if different_percent > Setting.first.max_diff_between_actual_track
         return self.track_type_id = 4
       end
    end

    # Check order type
    if (@track_place[0].include? 1) && (@track_place[1].include? 4)
      self.track_type_id = 1
    elsif (@track_place[0].include? 4) && (@track_place[1].include? 'begin_address')
      self.track_type_id = 2
    elsif (@track_place[0].include? 'begin_address') && (@track_place[1].include? 'end_address')
      self.track_type_id = 3
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
