require 'net/http'
require 'nokogiri'

# html = ''
# File.open("../var/dv.html") { |f| html = f.read }

req = Net::HTTP.get_response(URI.parse('http://dv.njtransit.com/mobile/tid-mobile.aspx?SID=NY'))
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

    departure = Departure.new({
      :trip_id => trip_id,
      :track => track,
      :day => Date.today,
    }).save!

    trip_id = nil
  end
end

