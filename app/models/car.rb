class Car < ActiveRecord::Base
  belongs_to :driver
  has_many :orders
  has_many :status_cars
  has_many :tracks
end
