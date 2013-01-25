class AddServiceIdToDepartures < ActiveRecord::Migration
  def up
    add_column :departures, :service_id, :integer
    Departure.reset_column_information
    Departure.all.each do |departure|
      departure.service = departure.calendar_date.service
      departure.save
    end
  end

  def down
    remove_column :departures, :service_id
  end
end
