require 'gtfs'
require 'title.rb'

namespace :gtfs do

  desc "Load GTFS data from a zip file into memory"
  task :load_into_memory => :environment do
    $nj_transit = GTFS::Source.build(File.join(Rails.root, 'var', 'njt-gtfs.zip'))
  end

  desc "Save all GTFS data into a database"
  task :all => [
    :load_into_memory,
    :save_agencies,
    :save_routes,
    :save_calendar_dates,
    # :save_shapes,
    :save_stop_times,
    :save_trips,
    :save_stops,
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

  desc "Save Routes to a database"
  task :save_routes => :load_into_memory do
    Route.truncate

    $nj_transit.each_route do |old_obj|
      short_name = old_obj.short_name.blank? ? Title.new(old_obj.long_name).initials : old_obj.short_name
      long_name = old_obj.long_name

      # Inexplicable special case. Seems to be a special case of the
      # Gladstone line that includes Seacaucus and excludes East Orange,
      # Hoboken, and Mountain Station.
      if long_name.blank? && short_name.eql?('MNRG')
        long_name = 'Gladstone Branch'
      end

      new_obj = Route.new do |obj|
        obj.id = old_obj.id.to_i
        obj.agency_id = old_obj.agency_id.to_i
        obj.short_name = short_name
        obj.long_name = long_name
        obj.route_type = old_obj.type
        obj.url = old_obj.url
        obj.color = old_obj.color
      end
      new_obj.save
    end
  end

  desc "Save CalendarDates to a database"
  task :save_calendar_dates => :load_into_memory do
    CalendarDateService.truncate

    $nj_transit.each_calendar_date do |old_obj|
      calendar_date = CalendarDate.find_or_create! :id => old_obj.date.to_i
      service = Service.find_or_create! :id => old_obj.service_id.to_i

      new_obj = CalendarDateService.new do |obj|
        obj.calendar_date_id = calendar_date.id
        obj.service_id = service.id
        obj.exception_type = old_obj.exception_type
      end
      new_obj.save
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
      desc = old_obj.desc.blank? ? old_obj.name : old_obj.desc

      if 42545.eql?(old_obj.id.to_i)
        old_name = "#{old_obj.name} Transfer"
      else
        old_name = old_obj.name
      end
      title = Title.new old_name

      route_type = StopTime.where(:stop_id => old_obj.id).first.trip.route.route_type

      new_obj = Stop.new do |obj|
        obj.id = old_obj.id
        obj.slug = title.parameterized
        obj.short_name = title.short
        obj.long_name = title.long
        obj.latitude = old_obj.lat
        obj.longitude = old_obj.lon
        obj.code = old_obj.code
        obj.description = desc
        obj.zone = old_obj.zone_id
        obj.route_type = route_type
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
      block = Block.find_or_create! :id => old_obj.block_id.to_i
      service = Service.find_or_create! :id => old_obj.service_id.to_i

      new_obj = Trip.new do |obj|
        obj.id = old_obj.id

        obj.block = block
        obj.service = service

        obj.route_id = old_obj.route_id
        obj.shape_id = old_obj.shape_id
        obj.direction_id = old_obj.direction_id
        obj.headsign = old_obj.headsign
      end
      new_obj.save
    end
  end

end
