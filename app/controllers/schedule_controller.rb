require 'schedule'
require 'pseudo_time'

class ScheduleController < ApplicationController
  # GET /schedule
  # GET /schedule.json
  def index
    @start = Time.now
    @now = CalendarDate.local_time
    @schedule = Schedule.new params['origin'], params['destination']
    @trips = @schedule.today
    @departs_ny_penn = @schedule.origin.id.eql?(Schedule::NEW_YORK_PENN_ID)
    @time_template = PseudoTime::TIME_TEMPLATE
    @stations = Stop.where(:route_type => Schedule::NJT_RAIL_ROUTE_TYPE).order(:short_name).all

    respond_to do |format|
      format.html # index.html.erb
      # TODO: Trim the fat for mobile.
      format.json {
        render(
          :json => {
            :schedule => @schedule,
            :trips => @trips,
            :departure_times => @trips.map { |trip| @schedule.origin_time(trip).strftime(@time_template).strip },
            :arrival_times => @trips.map { |trip| @schedule.destination_time(trip).strftime(@time_template).strip },
            :departs_ny_penn => @departs_ny_penn,
            :stations => @stations,
          }
        )
      }
    end
  end
end
