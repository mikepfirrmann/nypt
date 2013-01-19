class CreateStopTimes < ActiveRecord::Migration
  def change
    create_table :stop_times do |t|
      t.time :arrival_time
      t.time :departure_time
      t.integer :sequence
      t.integer :pickup_type
      t.integer :drop_off_type
      t.float :distance_traveled

      t.timestamps
    end
  end
end
