class DayPlaylist < ActiveRecord::Base
  attr_accessible :comment_count, :day_view_count, :dislikes, :favorite_count, :imported_date
  attr_accessible :likes, :playlist_id, :rater_count, :rating_average, :unique_id, :view_count, :video_count
  belongs_to :playlist
end

