class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :headsign
      t.integer :direction_id
      t.string :block_id

      t.timestamps
    end
  end
end
