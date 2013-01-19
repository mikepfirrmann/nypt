class CreateDepartures < ActiveRecord::Migration
  def change
    create_table :departures do |t|
      t.string :trip_id
      t.integer :track
      t.date :day

      t.timestamps
    end

    add_index :departures, [:trip_id, :day], {:unique => true}
  end
end
