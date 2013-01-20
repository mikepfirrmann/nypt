class CreateStopTimes < ActiveRecord::Migration
  def change
    create_table :stop_times do |t|
      t.integer :trip_id
      t.integer :stop_id
      t.time :arrival_time
      t.time :departure_time
      t.integer :sequence
      t.integer :pickup_type
      t.integer :drop_off_type
      t.float :distance_traveled

      t.timestamps
    end

    add_index :stop_times, :trip_id
    add_index :stop_times, :stop_id
  end
end
