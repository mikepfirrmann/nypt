class ChangeTripBlockIdType < ActiveRecord::Migration
  def up
    change_column :trips, :block_id, :integer
  end

  def down
    change_column :trips, :block_id, :string
  end
end
