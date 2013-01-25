class Block < ActiveRecord::Base
  has_many :trips
  has_many :departures
end
