require 'net/http'
require 'nokogiri'

NYP_DEPARTURE_VISION_URL = 'http://dv.njtransit.com/mobile/tid-mobile.aspx?SID=NY'

namespace :nypt do
  desc "Save any listed track numbers for New York Penn Station departures"
  task :save_departures => :environment do

    req = Net::HTTP.get_response(URI.parse(NYP_DEPARTURE_VISION_URL))
    html = req.body

    html_document = Nokogiri::HTML(html)
    rows = html_document.css('table')[1].css('tr')

    block_id = nil
    rows.each do |row|
      columns = row.css('td').map { |col| col.content.strip }

      if block_id.nil?
        time, block_id = columns.first.gsub(/\s/, '').split('/')
      else
        track = columns.first.gsub(/[^0-9]/, '').to_i

        if track > 0
          calendar_date = CalendarDate.for_time time
          block = Block.where(:id => block_id.to_i).first

          if calendar_date && block
            if departure = Departure.where(
              :calendar_date_id => calendar_date.id,
              :block_id => block.id
            ).first
              unless track.eql?(departure.track)
                departure.track = track
                departure.save
              end
            else
              departure = Departure.new do |departure|
                departure.block_id = block.id
                departure.calendar_date_id = calendar_date.id
                departure.service_id = calendar_date.service.id
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
