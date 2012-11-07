class CreateTrackers < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
      t.string :type
      t.string :unique_id
      t.string :this_week_rank
      t.string :last_week_rank
      t.string :name
      t.string :weeks_on_chart
      t.integer :total_aggregate_views
      t.integer :this_week_views
      t.string :plus_minus_views
      t.string :time_since_upload
      t.integer :comments
      t.integer :shares
      t.integer :videos_in_series
      t.datetime :tracked_date

      t.timestamps
    end
  end
end

