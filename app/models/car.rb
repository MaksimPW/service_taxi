class Car < ActiveRecord::Base
  belongs_to :driver
  has_many :orders
  has_many :status_cars
  has_many :tracks

  def define_tracks(datetime_begin, datetime_end)
    locations = StatusCar.where(fixed_time: datetime_begin..datetime_end, car_id: self.id)
    orders = Order.where("take_time >= ? AND end_time <= ? AND car_id = ?", datetime_begin, datetime_end, self.id)

    @tracks = Array.new

    @interval = [datetime_begin]
    orders.each do |o|
      @interval << o.take_time
      @interval << o.end_time
    end
    @interval << datetime_end

    (@interval.count-1).times { |i| @tracks << locations.where(fixed_time: @interval[i]..@interval[i+1]) }

    @tracks.each do |t|
      unless t.empty?
        track = Track.create(begin_time: t.first.fixed_time, end_time: t.last.fixed_time, car_id: self.id)
        t.each do |status_car|
          status_car.track_id = track.id
          status_car.save
        end

        order = Order.where("take_time <= ? AND end_time >= ? AND car_id = ?", track.begin_time, track.end_time, track.car_id).first
        if order
          track.order_id = order.id
        end
        track.save
      end
    end
  end
end
