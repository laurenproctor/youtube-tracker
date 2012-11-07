class CreateDayVideos < ActiveRecord::Migration
  def change
    create_table :day_videos do |t|
      t.integer :video_id
      t.datetime :imported_date
      t.string :unique_id
      t.integer :day_view_count
      t.integer :view_count
      t.integer :favorite_count
      t.integer :comment_count
      t.string :state
      t.integer :rating_min
      t.integer :rating_max
      t.decimal :rating_average, :precision => 8, :scale => 7
      t.integer :rater_count
      t.integer :likes
      t.integer :dislikes

      t.timestamps
    end
    add_index :day_videos, :video_id
    add_index :day_videos, :imported_date
    add_index :day_videos, :unique_id
    add_index :day_videos, :view_count
    add_index :day_videos, :day_view_count
    add_index :day_videos, :rating_average
  end
end

