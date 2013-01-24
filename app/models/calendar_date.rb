class CalendarDate < ActiveRecord::Base
  def self.date_integer
    local_time.strftime('%Y%m%d').to_i
  end

  def for_time(time_string)
    # If it is in the 11PM hour and the input time is in the 12AM hour,
    # the date for the string is tomorrow.
    if local_time.strftime('%H').to_i.eql?(23) && time_string.strip.to_i.eql?(12)
      return tomorrow
    end

    today
  end

  def self.local_time
    timezone_identifier = Agency.first.timezone

    timezone_name = ActiveSupport::TimeZone::MAPPING.key(timezone_identifier)
    timezone = ActiveSupport::TimeZone.all.select { |tz| tz.name.eql?(timezone_name) }.first

    timezone.now
  end

  def self.today
    where(:id => date_integer).first
  end

  def self.tomorrow
    where(:id => date_integer+1).first
  end
end
