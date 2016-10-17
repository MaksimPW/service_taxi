class AddTrackToStatusCars < ActiveRecord::Migration
  def change
    add_reference :status_cars, :track, index: true, foreign_key: true
  end
end
