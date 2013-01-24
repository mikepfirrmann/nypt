require 'gtfs'

namespace :gtfs do

  desc "Load GTFS data from a zip file into memory"
  task :load_into_memory => :environment do
    $nj_transit = GTFS::Source.build(File.join(Rails.root, 'var', 'njt-gtfs.zip'))
  end

  desc "Save all GTFS data into a database"
  task :all => [
    :load_into_memory,
    :save_agencies,
    :save_calendar_dates,
    # :save_shapes,
    :save_stops,
    :save_stop_times,
    :save_trips,
  ]

  desc "Save Agencies to a database"
  task :save_agencies => :load_into_memory do
    Agency.truncate

    $nj_transit.each_agency do |old_obj|
      new_obj = Agency.new do |obj|
        obj.id = old_obj.id.to_i
        obj.name = old_obj.name
        obj.url = old_obj.url
        obj.timezone = old_obj.timezone
        obj.language = old_obj.lang
        obj.phone = old_obj.phone.empty? ? nil : old_obj.phone
      end
      new_obj.save
    end
  end

  desc "Save CalendarDates to a database"
  task :save_calendar_dates => :load_into_memory do
    $nj_transit.each_calendar_date do |old_obj|
      date = old_obj.date.to_i

      if caledar_date = CalendarDate.where(:id => date).first
        next if caledar_date.service_id.eql?(old_obj.service_id)
        next if caledar_date.exception_type.eql?(old_obj.exception_type)

        caledar_date.service_id = old_obj.service_id
        caledar_date.exception_type = old_obj.exception_type

        caledar_date.save
      else
        new_obj = CalendarDate.new do |obj|
          obj.id = date
          obj.service_id = old_obj.service_id
          obj.exception_type = old_obj.exception_type
        end
        new_obj.save
      end
    end
  end

  desc "Save Shapes to a database"
  task :save_shapes => :load_into_memory do
    Shape.truncate

    # This is too big. Takes too long. Don't do this. If we need shapes, read file line by line.
    $nj_transit.each_shape do |old_obj|
# puts "#{old_obj.id}, #{old_obj.pt_lat}, #{old_obj.pt_lon}"
      # new_obj = Shape.new do |obj|
      #   obj.id = old_obj.id
      #   obj.latitude = old_obj.pt_lat
      #   obj.longitude = old_obj.pt_lon
      #   obj.sequence = old_obj.pt_sequence
      #   obj.distance_traveled = old_obj.dist_traveled
      # end
      # new_obj.save
    end
  end

  desc "Save Stops to a database"
  task :save_stops => :load_into_memory do
    Stop.truncate

    $nj_transit.each_stop do |old_obj|
      new_obj = Stop.new do |obj|
        obj.id = old_obj.id
        obj.long_name = old_obj.name
        obj.latitude = old_obj.lat
        obj.longitude = old_obj.lon
        obj.code = old_obj.code
        obj.description = old_obj.desc
        obj.zone = old_obj.zone_id
      end
      new_obj.save
    end
  end

  desc "Save Stop Times to a database"
  task :save_stop_times => :load_into_memory do
    StopTime.truncate

    $nj_transit.each_stop_time do |old_obj|
      new_obj = StopTime.new do |obj|
        obj.trip_id = old_obj.trip_id
        obj.stop_id = old_obj.stop_id
        obj.arrival_time = old_obj.arrival_time
        obj.departure_time = old_obj.departure_time
        obj.sequence = old_obj.stop_sequence
        obj.pickup_type = old_obj.pickup_type
        obj.drop_off_type = old_obj.drop_off_type
        obj.distance_traveled = old_obj.shape_dist_traveled
      end
      new_obj.save
    end
  end

  desc "Save Trips to a database"
  task :save_trips => :load_into_memory do
    Trip.truncate

    $nj_transit.each_trip do |old_obj|
      new_obj = Trip.new do |obj|
        obj.id = old_obj.id
        obj.route_id = old_obj.route_id
        obj.service_id = old_obj.service_id
        obj.shape_id = old_obj.shape_id
        obj.direction_id = old_obj.direction_id
        obj.headsign = old_obj.headsign
        obj.block_id = old_obj.block_id
      end
      new_obj.save
    end
  end

end
