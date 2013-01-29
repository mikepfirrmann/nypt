class AddStopSlug < ActiveRecord::Migration
  def up
    add_column :stops, :slug, :string
    add_column :stops, :route_type, :integer

    add_index :stops, :slug
    add_index :stops, :route_type
    add_index :stops, [:slug, :route_type], :name => "slug_and_route_type", :unique => true
  end

  def down
    remove_index :stops, :name => "slug_and_route_type"

    remove_column :stops, :slug
    remove_column :stops, :route_type
  end
end
