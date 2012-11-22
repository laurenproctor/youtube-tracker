class AddPlaylistIdToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :playlist_id, :integer
  end
end
