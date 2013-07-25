class Schedule
  NEW_YORK_PENN_ID = 105
  MORRIS_PLAINS_ID = 91

  NJT_RAIL_ROUTE_TYPE = 2

  attr_reader :origin, :destination, :calendar_date

  def initialize(origin_id = nil, destination_id = nil, calendar_date_id = nil)
    if origin_id.is_a?(Fixnum) || origin_id.nil?
      @origin = Stop.find(origin_id || NEW_YORK_PENN_ID)
    elsif origin_id.is_a?(String)
      @origin = Stop.where(:route_type => NJT_RAIL_ROUTE_TYPE, :slug => origin_id).first
    end

    if destination_id.is_a?(Fixnum) || destination_id.nil?
      @destination = Stop.find(destination_id || MORRIS_PLAINS_ID)
    elsif destination_id.is_a?(String)
      @destination = Stop.where(:route_type => NJT_RAIL_ROUTE_TYPE, :slug => destination_id).first
    end

    @calendar_date = CalendarDate.find(calendar_date_id) rescue CalendarDate.today
  end

  def trips
    trips = Trip.
    where(:service_id => @calendar_date.services.map(&:id)).
    joins('JOIN `stop_times` AS `s1` ON `s1`.`trip_id`=`trips`.`id`').
    joins('JOIN `stop_times` AS `s2` ON `s2`.`trip_id`=`trips`.`id`').
    where('`s1`.`stop_id`=? AND `s2`.`stop_id`=? AND `s1`.`sequence` < `s2`.`sequence`', @origin.id, @destination.id).
    order('`s1`.`departure_time`').
    all
  end

  def origin_time(trip)
    stop_time(trip, @origin)
  end

  def destination_time(trip)
    stop_time(trip, @destination)
  end

  protected

  def stop_time(trip, stop)
    trip.stop_times.select {|t| t.stop_id.eql?(stop.id) }.first.departure_time.real_local_time
  end
end
