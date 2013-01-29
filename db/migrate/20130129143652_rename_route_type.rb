class RenameRouteType < ActiveRecord::Migration
  def up
    rename_column :routes, :type, :route_type
  end

  def down
    rename_column :routes, :route_type, :type
  end
end
