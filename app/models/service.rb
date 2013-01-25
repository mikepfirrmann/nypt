class Service < ActiveRecord::Base
  has_many :trips
  has_many :calendar_dates
  has_many :departures
end
