class StopTimesToStrings < ActiveRecord::Migration
  def up
    change_column :stop_times, :arrival_time, :string
    change_column :stop_times, :departure_time, :string
  end

  def down
    change_column :stop_times, :arrival_time, :time
    change_column :stop_times, :departure_time, :time
  end
end
