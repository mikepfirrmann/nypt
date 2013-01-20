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
    :save_shapes,
  ]

  desc "Save Agencies to a database"
  task :save_agencies => :load_into_memory do
    Agency.delete_all

    $nj_transit.agencies.map do |old_obj|
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
    CalendarDate.delete_all

    $nj_transit.calendar_dates.map do |old_obj|
      new_obj = CalendarDate.new do |obj|
        obj.service_id = old_obj.service_id
        obj.date = old_obj.date
        obj.exception_type = old_obj.exception_type
      end
      new_obj.save
    end
  end

  desc "Save Shapes to a database"
  task :save_shapes => :load_into_memory do
    Shape.delete_all

    $nj_transit.shapes.map do |old_obj|
      new_obj = Shape.new do |obj|
        obj.id = old_obj.id
        obj.latitude = old_obj.pt_lat
        obj.longitude = old_obj.pt_lon
        obj.sequence = old_obj.sequence
        obj.distance_traveled = old_obj.dist_traveled
      end
      new_obj.save
    end
  end

end
