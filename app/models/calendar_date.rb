class CalendarDate < ActiveRecord::Base
  has_many :calendar_date_services
  has_many :services, :through => :calendar_date_services

  has_many :departures

  @@timezone = nil

  def self.date_integer
    local_time.strftime('%Y%m%d').to_i
  end

  def self.for_time(time_string)
    current_hour = local_time.strftime('%H').to_i
    input_hour = time_string.strip.to_i

    # If it is between midnight and 4am and the input hour is between midnight
    # and 3am, treat the input time as belonging to yesterday.
    if (current_hour < 4) && [12, 1, 2, 3].include?(input_hour)
      return yesterday
    end

    today
  end

  def self.from_date(date)
    where(:id => date.strftime('%Y%m%d')).first
  end

  def self.local_time(time_str = nil)
    return timezone.now if time_str.nil?

    timezone.parse(time_str)
  end

  def self.timezone
    if @@timezone.nil?
      timezone_identifier = Agency.first.timezone

      timezone_name = ActiveSupport::TimeZone::MAPPING.key(timezone_identifier)
      @@timezone = ActiveSupport::TimeZone.all.select { |tz| tz.name.eql?(timezone_name) }.first
    end

    @@timezone
  end

  def self.today
    where(:id => date_integer).first
  end

  def self.tomorrow
    where(:id => date_integer+1).first
  end

  def self.yesterday
    where(:id => date_integer-1).first
  end

  def to_date
    DateTime.parse(self.id.to_s).to_date
  end
end
