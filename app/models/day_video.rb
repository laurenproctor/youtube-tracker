class DayVideo < ActiveRecord::Base
  attr_accessible :comment_count, :day_view_count, :dislikes, :imported_date
  attr_accessible :favorite_count, :likes, :rater_count, :rating_average, :rating_max, :rating_min
  attr_accessible :state, :unique_id, :video_id, :view_count, :report_date,
                  :day_comments,:day_favorites_added,:day_favorites_removed,:day_likes,
                  :day_dislikes,:day_shares,:day_subscribers_gained,:day_subscribers_lost,
                  :week_views,:report_date_wday
  belongs_to :video
  has_one :tracker, :as => :trackable

  def data_date
    self.imported_date.getlocal - 1.day
  end
end

