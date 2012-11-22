class AddChannelIdToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :channel_id, :integer
  end
end
