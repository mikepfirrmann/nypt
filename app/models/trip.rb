class Trip < ActiveRecord::Base
  belongs_to :route
  belongs_to :shape

  has_many :stop_times
  has_many :departures

  has_many :stops, :through => :stop_times
end
