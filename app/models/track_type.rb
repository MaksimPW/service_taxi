class TrackType < ActiveRecord::Base
  has_many :orders
  has_many :tracks
end
