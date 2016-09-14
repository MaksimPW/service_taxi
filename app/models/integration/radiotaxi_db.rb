class Integration::RadiotaxiDb < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "#{Rails.env}_integration_radiotaxi"
end
