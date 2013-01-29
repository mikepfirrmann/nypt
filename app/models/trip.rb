class Trip < ActiveRecord::Base
  belongs_to :route
  belongs_to :shape
  belongs_to :block
  belongs_to :service

  has_many :departures
  has_many :stop_times
  has_many :stops, :through => :stop_times

  def predict_track
    history = departures.sort_by { |d| d.calendar_date_id }.reverse

    return [] if history.empty?

    if CalendarDate.today.eql?(history.first.calendar_date)
      return [{
        :number => history.first.track,
        :count => 1,
        :confidence => 1,
        :today => true,
      }]
    end

    track_counts = {}
    history.each do |departure|
      track_counts[departure.track] ||= 0
      track_counts[departure.track] += 1
    end

    tracks = []
    track_counts.each do |track, count|
      tracks << {
        :number => track,
        :count => count,
        :confidence => count.to_f / history.size.to_f,
        :today => false,
      }
    end

    tracks.sort_by { |t| -1 * t[:confidence]}
  end

end
