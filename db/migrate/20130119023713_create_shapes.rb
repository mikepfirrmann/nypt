class CreateShapes < ActiveRecord::Migration
  def change
    create_table :shapes do |t|
      t.float :latitude
      t.float :longitude
      t.integer :sequence
      t.float :distance_traveled

      t.timestamps
    end
  end
end
