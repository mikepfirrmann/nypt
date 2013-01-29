class StripDownCalendarDate < ActiveRecord::Migration
  def up
    remove_index :calendar_dates, :column => :service_id
    remove_column :calendar_dates, :service_id
    remove_column :calendar_dates, :date
    remove_column :calendar_dates, :exception_type
  end

  def down
    add_column :calendar_dates, :service_id, :integer
    add_column :calendar_dates, :date, :string
    add_column :calendar_dates, :exception_type, :integer

    add_index :calendar_dates, :service_id
  end
end
