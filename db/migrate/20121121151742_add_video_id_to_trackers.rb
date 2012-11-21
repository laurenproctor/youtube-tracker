class AddVideoIdToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :video_id, :integer
  end
end
