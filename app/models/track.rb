class Track < ActiveRecord::Base
  has_many :status_cars
  belongs_to :car
  belongs_to :order
  belongs_to :track_type
end
