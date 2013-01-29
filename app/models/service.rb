class Service < ActiveRecord::Base
  has_many :trips
  has_many :departures

  has_many :calendar_date_services
  has_many :calendar_dates, :through => :calendar_date_services
end
