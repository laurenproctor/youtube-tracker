class CreateTrackers < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
      t.string :type
      t.string :unique_id
      t.integer :this_week_rank
      t.integer :last_week_rank
      t.string :name
      t.integer :weeks_on_chart
      t.integer :total_aggregate_views
      t.integer :this_week_views
      t.string :weekly_percent_views
      t.decimal :time_since_upload
      t.integer :comments
      t.integer :shares
      t.integer :videos_in_series
      t.datetime :tracked_date
      t.datetime :uploaded_at

      t.timestamps
    end
  end
end

