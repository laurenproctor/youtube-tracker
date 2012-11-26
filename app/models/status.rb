class Status < ActiveRecord::Base
  attr_accessible :avg_view_duration, :avg_views, :fb_likes, :instagram_followers, :lifetime_views,
                  :minutes_watched, :plus_followers, :subscribers, :tumblr_followers, :twitter_followers,
                  :vscr, :user_id , :imported_date, :channel_id, :report_date,
                  :day_avg_views, :day_avg_view_duration, :day_vscr, :day_views,
                  :day_minutes_watched, :day_subscribers, :day_fb_likes, :day_twitter_followers,
                  :day_plus_followers, :day_tumblr_followers, :day_instagram_followers

  belongs_to :channel

end

