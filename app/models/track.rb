class Track < ActiveRecord::Base
  has_many :status_cars
  belongs_to :car
  belongs_to :order
  belongs_to :track_type

  def self.get_time_track(track_statuses)
    track_statuses.last.fixed_time - track_statuses.first.fixed_time
  end

  def get_stay_tracks
    @max_stay_speed = Setting.first.max_stay_speed
    @stay_lines = Array.new
    @stay_lines_index = -1

    self.status_cars.each_with_index do |status, index|
      previous_status = self.status_cars[index-1] unless index ==0
      unless previous_status
        if status.speed <= @max_stay_speed
          @stay_lines[@stay_lines_index+=1] = [status]
        end
      else
        if status.speed <= @max_stay_speed && previous_status.speed > @max_stay_speed
          @stay_lines[@stay_lines_index+=1] = [status]
        elsif status.speed <= @max_stay_speed
          @stay_lines[@stay_lines_index] << status
        end
      end
    end
    @stay_lines
  end

  def define_type
    @status_cars = self.status_cars

    if @status_cars.count <= 1
      return self.track_type_id = 5
    end

    # Check location in places
    @track_place = Array.new(2,[])
    @track_place[0] = @status_cars.first.get_places
    @track_place[1] = @status_cars.last.get_places

    if !self.order_id.nil?
      @order = self.order
      # For order track
      # Check location nearby with order begin/end addresses
      [@status_cars.first, @status_cars.last].each_with_index do |location, index|
        if Geocoder::Calculations.distance_between([location.geo_lat, location.geo_lon],
                                                   [@order.begin_lat, @order.begin_lon],
                                                   units: :km) <= Setting.first.max_park_distance_after_order
          @track_place[index] << 'begin_address'
        end

        if Geocoder::Calculations.distance_between([location.geo_lat, location.geo_lon],
                                                   [@order.end_lat, @order.end_lon],
                                                   units: :km) <= Setting.first.max_park_distance_after_order
          @track_place[index] << 'end_address'
        end
      end

      return puts "@order.distance nil" if @order.distance.nil?
      @actual_distance = Inspection.summary_build_route(@status_cars.pluck(:id))["length"]

      if @actual_distance > @order.distance
        different_percent = (100 - @order.distance.to_f/@actual_distance.to_f*100)
        if different_percent > Setting.first.max_diff_between_actual_track
          return self.track_type_id = 4
        end
      end

      # Check track type with order
      if (@track_place[0].include? 'begin_address') && (@track_place[1].include? 'end_address')
        return self.track_type_id = 3
      else
        return self.track_type_id = 6
      end
    else
      # For other track

      @status_cars_places = Array.new
      @status_cars.each do |status|
        @status_cars_places << status.get_places
      end

      if (@status_cars_places.flatten.include?(3))
        return self.track_type_id = 10
      end

      @stay_tracks = self.get_stay_tracks
      if @stay_tracks
        @max_time_stay_track = 0

        @prev_order = Order.where("take_time < ? AND car_id = ?", @status_cars.first.fixed_time, self.car_id).last
        @next_order = Order.where("take_time > ? AND car_id = ?", @status_cars.last.fixed_time, self.car_id).first
        if @prev_order && @next_order
          @stay_tracks.each do |stay_track|
            time_stay_track = Track.get_time_track(stay_track)
            @max_time_stay_track = time_stay_track if time_stay_track > @max_time_stay_track

            stay_track.each do |status|
              if Geocoder::Calculations.distance_between([status.geo_lat, status.geo_lon],
                                                         [@prev_order.end_lat, @prev_order.end_lon],
                                                         units: :km) <= Setting.first.max_park_distance_after_order
                @track_place[1] << 'end_address'
              end
            end
          end
          if (@track_place[1].flatten.include? 'end_address') && (@max_time_stay_track <= Setting.first.max_rest_time_after_order)
            return self.track_type_id = 8
          end
        end

        @stay_track_place = Array.new
        @stay_tracks.each do |stay_track|

          time_stay_track = Track.get_time_track(stay_track)
          @max_time_stay_track = time_stay_track if time_stay_track > @max_time_stay_track
          stay_track.each do |status|
            @stay_track_place << status.get_places
          end
        end

        if (@stay_track_place.flatten.include?(1)) && (@max_time_stay_track <= Setting.first.max_rest_time)
          return self.track_type_id = 9
        end

        if (@max_time_stay_track >= Setting.first.max_rest_time_after_order) && (@max_time_stay_track <= Setting.first.max_park_time)
          return self.track_type_id = 11
        elsif @max_time_stay_track > Setting.first.max_park_time
          return self.track_type_id = 12
        end
      end

      @date = @status_cars.first.fixed_time.to_date
      @first_order = Order.where("take_time > ? AND car_id = ?", @date, self.car_id).first

      if @first_order.take_time > @status_cars.first.fixed_time
        if Geocoder::Calculations.distance_between([@status_cars.last.geo_lat, @status_cars.last.geo_lon],
                                                   [@first_order.begin_lat, @first_order.begin_lon],
                                                   units: :km) <= Setting.first.max_park_distance_after_order
          @track_place[1] << 'begin_address'
        end

        @track_places = Array.new
        @status_cars.each do |status_car|
          @track_places << status_car.get_places
        end

        if (@track_place[0].include? 1) && (@track_places.flatten.include? 4) && (@track_place[1].include? 'begin_address')
          return self.track_type_id = 7
        end
      end

      @last_order = Order.where("take_time > ? AND car_id = ?", @date, self.car_id).last
      if @last_order.take_time < @status_cars.first.fixed_time
        if Geocoder::Calculations.distance_between([@status_cars.first.geo_lat, @status_cars.first.geo_lon], [@last_order.end_lat, @last_order.end_lon], units: :km) <= Setting.first.max_park_distance_after_order
          @track_place[0] << 'end_address'
        end

        if (@track_place[0].include? 'end_address') && (@track_place[1].include?(1))
          return self.track_type_id = 13
        end
      end
    end
  end
end
