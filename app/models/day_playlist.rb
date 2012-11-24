class DayPlaylist < ActiveRecord::Base
  serialize :video_unique_ids, Array
  attr_accessible :comment_count, :day_view_count, :dislikes, :favorite_count, :imported_date
  attr_accessible :likes, :playlist_id, :rater_count, :rating_average, :unique_id, :view_count,
                  :video_count, :video_unique_ids, :report_date
  belongs_to :playlist

  has_one :tracker, :as => :trackable
end

