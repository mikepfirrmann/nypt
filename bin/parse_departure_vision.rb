require 'gtfs'
require 'nokogiri'
require '../lib/departure.rb'

html = ''
File.open("../var/dv.html") { |f| html = f.read }

departures = []

html_document = Nokogiri::HTML(html)
rows = html_document.css('table')[1].css('tr')

trip_id = nil
rows.each do |row|
  columns = row.css('td').map { |col| col.content.strip }

  if trip_id.nil?
    time, trip_id = columns.first.gsub(/\s/, '').split('/')
  else
    track = columns.first.gsub(/[^0-9]/, '').to_i
    # departure[:status] = columns.last

    departure = Departure.new trip_id, track
    departures << departure if departure.valid?

    trip_id = nil
  end
end

puts departures
