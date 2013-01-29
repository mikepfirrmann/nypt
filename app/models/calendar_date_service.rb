class CalendarDateService < ActiveRecord::Base
  belongs_to :calendar_date
  belongs_to :service
end
