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

    @destination = nil
    if params[:destination]
      @destination = Stop.where(:slug => params[:destination]).first
    end

    @track_history = @trip.history

    respond_to do |format|
      format.html # show.html.erb
      # TODO: Trim the fat for mobile.
      format.json {
        render(
          :json => {
            :trip => @trip,
            :stations => @stations,
            :arrival_times => @arrival_times,
            :destination => @destination,
            :track_history => @track_history,
          }
        )
      }
    end
  end
end
