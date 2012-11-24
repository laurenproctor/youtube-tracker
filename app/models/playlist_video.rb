class PlaylistVideo < ActiveRecord::Base
  attr_accessible :comment_count, :day_view_count, :dislikes, :favorite_count,
                  :imported_date, :likes, :playlist_unique_id, :rater_count,
                  :rating_average, :video_unique_id, :view_count, :author_name, :author_uri,
                  :published_at, :uploaded_at, :report_date
end

