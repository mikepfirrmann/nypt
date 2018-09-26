class Trip < ActiveRecord::Base
  MAXIMUM_DAYS_BETWEEN_DEPARTURES = 10

  belongs_to :route
  belongs_to :shape
  belongs_to :block
  belongs_to :service

  has_many :departures
  has_many :stop_times
  has_many :stops, :through => :stop_times

  def history
    complete_history = departures.sort_by { |d| d.calendar_date_id }.reverse

    last_usable_index = 0

    date_history = complete_history.map { |d| d.calendar_date.id }
    date_history.each_with_index do |date, index|
      previous_date = date_history[index + 1]
      next if previous_date.nil?

      days_since_last_departure = date - previous_date

      if days_since_last_departure > MAXIMUM_DAYS_BETWEEN_DEPARTURES
        last_usable_index = index
        break
      end
    end

    complete_history.first(last_usable_index + 1)
  end

  def predict_track
    history = self.history

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
