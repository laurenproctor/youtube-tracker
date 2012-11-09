class CreatePlaylistVideos < ActiveRecord::Migration
  def change
    create_table :playlist_videos do |t|
      t.string :playlist_unique_id
      t.string :video_unique_id
      t.integer :comment_count
      t.integer :dislikes
      t.integer :likes
      t.integer :favorite_count
      t.integer :rater_count
      t.integer :rating_average
      t.integer :view_count
      t.integer :day_view_count
      t.datetime :imported_date
      t.string :author_name
      t.string :author_uri

      t.timestamps
    end
    add_index :playlist_videos, :imported_date
    add_index :playlist_videos, :playlist_unique_id
    add_index :playlist_videos, :video_unique_id
    add_index :playlist_videos, :view_count
    add_index :playlist_videos, :day_view_count
    add_index :playlist_videos, :rating_average
  end
end

