require 'pseudo_time'

class TripsController < ApplicationController
  # GET /trips/1
  # GET /trips/1.json
  def show
    @start = Time.now
    @trip = Trip.find(params[:id])
    stop_times = @trip.stop_times.all
    @stations = stop_times.map(&:stop)
    @arrival_times = stop_times.map {|stop_time| stop_time.arrival_time.real_local_time}
    @time_template = PseudoTime::TIME_TEMPLATE

    @origin
    if params[:origin]
      @origin = Stop.where(:slug => params[:origin]).first
    end
    @destination = nil
    if params[:destination]
      @destination = Stop.where(:slug => params[:destination]).first
    end

    @departure_time = stop_times.select { |t| t.stop.eql?(@origin) }.first.arrival_time.real_local_time

    @on = CalendarDate.where(:id => params[:on]).first

    @track_history = @trip.history

    respond_to do |format|
      format.html # show.html.erb
      # TODO: Trim the fat for mobile.
      format.json {
        render(
          :json => {
            :trip => @trip,
            :stations => @stations,
            :departure_time => @departure_time,
            :arrival_times => @arrival_times,
            :destination => @destination,
            :track_history => @track_history,
            :on => @on,
          }
        )
      }
    end
  end
end
