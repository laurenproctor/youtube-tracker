class AddPercentChangeViewsForTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :percent_change_views, :decimal, :precision => 10, :scale => 4
  end
end

