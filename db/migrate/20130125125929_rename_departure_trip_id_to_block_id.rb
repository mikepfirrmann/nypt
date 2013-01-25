class RenameDepartureTripIdToBlockId < ActiveRecord::Migration
  def up
    rename_column :departures, :trip_id, :block_id
  end

  def down
    rename_column :departures, :block_id, :trip_id
  end
end
