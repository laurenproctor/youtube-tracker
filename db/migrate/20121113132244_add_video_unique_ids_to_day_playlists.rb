class AddVideoUniqueIdsToDayPlaylists < ActiveRecord::Migration
  def change
    add_column :day_playlists, :video_unique_ids, :text
  end
end
