class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.integer :route_id
      t.integer :service_id
      t.integer :shape_id
      t.string :headsign
      t.integer :direction_id
      t.string :block_id

      t.timestamps
    end

    add_index :trips, :route_id
    add_index :trips, :service_id
    add_index :trips, :shape_id
  end
end
