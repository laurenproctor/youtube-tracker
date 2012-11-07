class DayVideo < ActiveRecord::Base
  attr_accessible :comment_count, :day_view_count, :dislikes, :imported_date
  attr_accessible :favorite_count, :likes, :rater_count, :rating_average, :rating_max, :rating_min
  attr_accessible :state, :unique_id, :video_id, :view_count
end

