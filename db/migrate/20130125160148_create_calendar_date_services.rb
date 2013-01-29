class CreateCalendarDateServices < ActiveRecord::Migration
  def change
    create_table :calendar_date_services do |t|
      t.integer :calendar_date_id
      t.integer :service_id
      t.integer :exception_type

      t.timestamps
    end

    add_index :calendar_date_services, :calendar_date_id
    add_index :calendar_date_services, :service_id
  end
end
