class Status < ActiveRecord::Base
  attr_accessible :avg_view_duration, :avg_views, :fb_likes, :instagram_followers, :lifetime_views,
                  :minutes_watched, :plus_followers, :subscribers, :tumblr_followers, :twitter_followers,
                  :vscr, :user_id , :imported_date, :channel_id, :report_date

  belongs_to :channel

end

