class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.integer :code
      t.string :short_name
      t.string :long_name
      t.string :description
      t.float :latitude
      t.float :longitude
      t.integer :zone

      t.timestamps
    end
  end
end
