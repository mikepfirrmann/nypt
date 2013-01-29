# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130129145258) do

  create_table "agencies", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "timezone"
    t.string   "language"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blocks", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calendar_date_services", :force => true do |t|
    t.integer  "calendar_date_id"
    t.integer  "service_id"
    t.integer  "exception_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "calendar_date_services", ["calendar_date_id"], :name => "index_calendar_date_services_on_calendar_date_id"
  add_index "calendar_date_services", ["service_id"], :name => "index_calendar_date_services_on_service_id"

  create_table "calendar_dates", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departures", :force => true do |t|
    t.integer  "track"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "calendar_date_id"
    t.integer  "trip_id"
  end

  add_index "departures", ["trip_id", "calendar_date_id"], :name => "trip_id_and_calendar_date_id", :unique => true
  add_index "departures", ["trip_id"], :name => "index_departures_on_trip_id"

  create_table "routes", :force => true do |t|
    t.integer  "agency_id"
    t.string   "short_name"
    t.string   "long_name"
    t.integer  "route_type"
    t.string   "url"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "routes", ["agency_id"], :name => "index_routes_on_agency_id"

  create_table "services", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shapes", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "sequence"
    t.float    "distance_traveled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stop_times", :force => true do |t|
    t.integer  "trip_id"
    t.integer  "stop_id"
    t.string   "arrival_time"
    t.string   "departure_time"
    t.integer  "sequence"
    t.integer  "pickup_type"
    t.integer  "drop_off_type"
    t.float    "distance_traveled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stop_times", ["stop_id"], :name => "index_stop_times_on_stop_id"
  add_index "stop_times", ["trip_id"], :name => "index_stop_times_on_trip_id"

  create_table "stops", :force => true do |t|
    t.integer  "code"
    t.string   "short_name"
    t.string   "long_name"
    t.string   "description"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "zone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "route_type"
  end

  add_index "stops", ["route_type"], :name => "index_stops_on_route_type"
  add_index "stops", ["slug", "route_type"], :name => "slug_and_route_type", :unique => true
  add_index "stops", ["slug"], :name => "index_stops_on_slug"

  create_table "trips", :force => true do |t|
    t.integer  "route_id"
    t.integer  "service_id"
    t.integer  "shape_id"
    t.string   "headsign"
    t.integer  "direction_id"
    t.integer  "block_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trips", ["route_id"], :name => "index_trips_on_route_id"
  add_index "trips", ["service_id"], :name => "index_trips_on_service_id"
  add_index "trips", ["shape_id"], :name => "index_trips_on_shape_id"

end
