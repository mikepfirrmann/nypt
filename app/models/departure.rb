require 'gtfs'

class Departure < ActiveRecord::Base
  @@nj_transit = nil

  # Database columns
  attr_accessible :day, :track, :trip_id
  # attr_protected :trip_id

  attr_reader :trip, :stops

  before_validation :init_nj_transit

  validates :day, :presence => true
  validates :track, :numericality => { :only_integer => true, :greater_than => 0 }
  validate :trip_id, :validate_trip_id


  # after_initialize do
  #   init_stops if valid?
  # end

  # def to_s
  #   "#{@stops.first[:time]} departure to #{@stops.last[:name]} on track #{@track}"
  # end

  def validate_trip_id
    @trip = @@nj_transit.trips.select { |trip| trip.block_id.eql?(trip_id) }.first

    errors.add(:trip_id, "does not contain a valid Trip ID") unless @trip
  end

  protected
  def init_nj_transit
    return unless @@nj_transit.nil?
    @@nj_transit = GTFS::Source.build(File.join(Rails.root, 'var', 'njt-gtfs.zip'))
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
