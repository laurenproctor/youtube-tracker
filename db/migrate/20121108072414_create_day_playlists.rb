class CreateDayPlaylists < ActiveRecord::Migration
  def change
    create_table :day_playlists do |t|
      t.integer :comment_count
      t.integer :day_view_count
      t.integer :dislikes
      t.datetime :imported_date
      t.integer :favorite_count
      t.integer :likes
      t.integer :rater_count
      t.decimal :rating_average, :precision => 8, :scale => 7
      t.string :unique_id
      t.integer :playlist_id
      t.integer :view_count
      t.integer :video_count

      t.timestamps
    end
    add_index :day_playlists, :playlist_id
    add_index :day_playlists, :imported_date
    add_index :day_playlists, :unique_id
    add_index :day_playlists, :view_count
    add_index :day_playlists, :day_view_count
    add_index :day_playlists, :rating_average
    add_index :day_playlists, :video_count
  end
end

