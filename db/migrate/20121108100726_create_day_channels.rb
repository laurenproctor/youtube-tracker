class CreateDayChannels < ActiveRecord::Migration
  def change
    create_table :day_channels do |t|
      t.integer :channel_id
      t.string :unique_id
      t.integer :upload_count
      t.integer :subscribers
      t.integer :view_count
      t.integer :upload_views
      t.datetime :imported_date

      t.timestamps
    end
    add_index :day_channels, :channel_id
    add_index :day_channels, :imported_date
    add_index :day_channels, :unique_id
  end
end

