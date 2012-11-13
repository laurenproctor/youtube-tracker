class AddPublishedAtUploadedAtToPlaylistVideos < ActiveRecord::Migration
  def change
    add_column :playlist_videos, :published_at, :datetime
    add_column :playlist_videos, :uploaded_at, :datetime
  end
end
