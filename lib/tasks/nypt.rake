require 'net/http'
require 'nokogiri'

NYP_DEPARTURE_VISION_URL = 'http://dv.njtransit.com/mobile/tid-mobile.aspx?SID=NY'

namespace :nypt do
  desc "Save any listed track numbers for New York Penn Station departures"
  task :save_departures => :environment do

    response = Net::HTTP.get_response(URI.parse(NYP_DEPARTURE_VISION_URL))
    unless response.code.to_i.eql?(200)
      raise "Did not receive HTTP 200 response when requesting NYPT departure vision. Code: #{response.code}"
    end
    html = response.body
    raise "Received empty response for NYPT departure vision" if html.empty?

    unless html_document = Nokogiri::HTML(html)
      raise "Received invalid HTML for NYPT departure vision"
    end

    unless departure_table = html_document.css('table')[1]
      raise "Could not find departures table in NYPT departure vision DOM"
    end

    time = nil
    block_id = nil
    departure_table.css('tr').each do |row|
      columns = row.css('td').map { |col| col.content.strip }

      if block_id.nil?
        time, block_id = columns.first.gsub(/\s/, '').split('/')
      else
        track = columns.first.gsub(/[^0-9]/, '').to_i

        if track > 0
          calendar_date = CalendarDate.for_time time
          block = Block.where(:id => block_id.to_i).first

          if calendar_date && block
            trip = Trip.where(
              :service_id => calendar_date.services.map(&:id),
              :block_id => block.id
            ).first

            if departure = Departure.where(
              :calendar_date_id => calendar_date.id,
              :trip_id => trip.id
            ).first
              unless track.eql?(departure.track)
                departure.track = track
                departure.save
              end
            else
              departure = Departure.new do |departure|
                departure.trip_id = trip.id
                departure.calendar_date_id = calendar_date.id
                departure.track = track
              end
              departure.save
            end
          end
        end

        block_id = nil
      end
    end

  end
end
