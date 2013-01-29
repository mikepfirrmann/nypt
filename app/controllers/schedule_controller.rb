require 'schedule'

class ScheduleController < ApplicationController
  # GET /schedule
  # GET /schedule.json
  def index
    @start = Time.now
    @now = CalendarDate.local_time
    @schedule = Schedule.new params['origin'], params['destination']
    @trips = @schedule.today
    @departs_ny_penn = @schedule.origin.id.eql?(Schedule::NEW_YORK_PENN_ID)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trips }
    end
  end
end
