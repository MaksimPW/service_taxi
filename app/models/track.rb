class Track < ActiveRecord::Base
  has_many :status_cars
  belongs_to :car
  belongs_to :order
  belongs_to :track_type


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
    end
  end
end
