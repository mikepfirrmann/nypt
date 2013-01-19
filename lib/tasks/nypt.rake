require 'net/http'
require 'nokogiri'

NYP_DEPARTURE_VISION_URL = 'http://dv.njtransit.com/mobile/tid-mobile.aspx?SID=NY'

namespace :nypt do
  desc "Save any listed track numbers for New York Penn Station departures"
  task :save_departures => :environment do

    # html = ''
    # File.open("../var/dv.html") { |f| html = f.read }

    req = Net::HTTP.get_response(URI.parse(NYP_DEPARTURE_VISION_URL))
    html = req.body

    html_document = Nokogiri::HTML(html)
    rows = html_document.css('table')[1].css('tr')

    trip_id = nil
    rows.each do |row|
      columns = row.css('td').map { |col| col.content.strip }

      if trip_id.nil?
        time, trip_id = columns.first.gsub(/\s/, '').split('/')
      else
        track = columns.first.gsub(/[^0-9]/, '').to_i

        # If a departure was created with this trip_id in the last 12 hours,
        # only update it if the track assignment has changed. We can't simply
        # look for a Departure with the given trip_id and :day == Date.today
        # because of timezone issues.
        if departure = Departure.where(
          "created_at > ? AND trip_id = ?",
          Time.now - 12.hours,
          trip_id
        ).first
          departure.save unless track.eql?(departure.track)
        else
          departure = Departure.new({
            :trip_id => trip_id,
            :track => track,
            :day => Date.today,
          })
          departure.save
        end

        trip_id = nil
      end
    end

  end
end
