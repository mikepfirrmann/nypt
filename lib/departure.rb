class Departure

  @@nj_transit = nil

  attr_reader :trip, :track

  def initialize(trip_id, track)
    @track = track.to_i

    init_nj_transit

    @trip = @@nj_transit.trips.select { |t| t.block_id.eql?(trip_id) }.first
    init_stops if valid?
  end

  def to_s
    "#{@stops.first[:time]} departure to #{@stops.last[:name]} on track #{@track}"
  end

  def valid?
    !!@trip #&& (@track > 0)
  end

  protected
  def init_nj_transit
    return unless @@nj_transit.nil?
    @@nj_transit = GTFS::Source.build('../var/njt-gtfs.zip')
  end

  def init_stops
    return unless @stops.nil?

    @stops = []

    @@nj_transit.stop_times.select { |s| s.trip_id.eql?(@trip.id) }.each do |stop_time|
      stop = @@nj_transit.stops.select { |s| s.id.eql?(stop_time.stop_id) }.first
      next if stop.nil?

      @stops << {
        :name => stop.name,
        :time => stop_time.departure_time
      }
    end
  end
end
