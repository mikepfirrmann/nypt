class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.integer :agency_id
      t.string :short_name
      t.string :long_name
      t.integer :type
      t.string :url
      t.string :color

      t.timestamps
    end

    add_index :routes, :agency_id
  end
end
