class Schedule
  NEW_YORK_PENN_ID = 105
  MORRIS_PLAINS_ID = 91

  NJT_RAIL_ROUTE_TYPE = 2

  attr_reader :origin, :destination

  def initialize(origin_id = nil, destination_id = nil)
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
  end

  def today
    origin_stop_times = []
    destination_stop_times = []

    Trip.
      where(:service_id => CalendarDate.today.services.map(&:id)).
      includes(:stops).
      where(:stops => {:id => [@origin.id, @destination.id] }).
      includes(:stop_times).
      all.
      select do |trip|
        origin_time = trip.stop_times.select {|t| t.stop_id.eql?(@origin.id) }.first
        destination_time = trip.stop_times.select {|t| t.stop_id.eql?(@destination.id) }.first

        next(false) if origin_time.nil? || destination_time.nil?
        next(false) unless origin_time.departure_time < destination_time.departure_time
        next(true)
      end.
      sort_by {|t| t.stop_times.first.departure_time}
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
