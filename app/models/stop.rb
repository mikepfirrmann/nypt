class Stop < ActiveRecord::Base
  has_many :stop_times
  has_many :trips, :through => :stop_times
  has_many :routes, :through => :trips
  has_many :services, :through => :trips
end
