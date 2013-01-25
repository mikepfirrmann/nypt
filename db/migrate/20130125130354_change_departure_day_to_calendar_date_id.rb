class ChangeDepartureDayToCalendarDateId < ActiveRecord::Migration
  def up
    add_column :departures, :calendar_date_id, :integer
    Departure.reset_column_information
    Departure.all.each do |departure|
      if calendar_date = CalendarDate.where(:id => departure.day.to_s.gsub(/[^0-9]/, '').to_i).first
        departure.calendar_date = calendar_date
        departure.save
      end
    end
    remove_column :departures, :day
  end

  def down
    add_column :departures, :day, :date
    Departure.reset_column_information
    Departure.all.each do |departure|
      date_string = departure.calendar_date.id.to_s
      departure.day = "#{date_string[0..3]}-#{date_string[4..5]}-#{date_string[6..7]}"
      departure.save
    end
    remove_column :departures, :calendar_date_id
  end
end
