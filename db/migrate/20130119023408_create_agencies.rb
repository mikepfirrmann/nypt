class CreateAgencies < ActiveRecord::Migration
  def change
    create_table :agencies do |t|
      t.string :name
      t.string :url
      t.string :timezone
      t.string :language
      t.string :phone

      t.timestamps
    end
  end
end
