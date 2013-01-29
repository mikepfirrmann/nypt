class AddTripBackToDepartures < ActiveRecord::Migration
  def up
    add_column :departures, :trip_id, :integer

    Departure.reset_column_information
    Departure.all.each do |departure|
      departure.trip = Trip.where(
        :service_id => departure.calendar_date.services.map(&:id),
        :block_id => departure.block.id
      ).first
      departure.save
    end

    remove_column :departures, :service_id
    remove_column :departures, :block_id

    add_index :departures, :trip_id
    add_index :departures, [:trip_id, :calendar_date_id], :name => "trip_id_and_calendar_date_id", :unique => true
  end

  def down
    add_column :departures, :service_id, :integer
    add_column :departures, :block_id, :integer

    Departure.reset_column_information
    Departure.all.each do |departure|
      departure.service = departure.trip.service
      departure.block = departure.trip.block
      departure.save
    end

    remove_column :departures, :trip_id
    remove_index :departures, :name => "trip_id_and_calendar_date_id"
  end
end
