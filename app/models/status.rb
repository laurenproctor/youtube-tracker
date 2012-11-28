class Status < ActiveRecord::Base
  attr_accessible :avg_view_duration, :avg_views, :fb_likes, :instagram_followers, :lifetime_views,
                  :minutes_watched, :plus_followers, :subscribers, :tumblr_followers, :twitter_followers,
                  :vscr, :user_id , :imported_date, :channel_id, :report_date,
                  :day_avg_views, :day_avg_view_duration, :day_vscr, :day_views,
                  :day_minutes_watched, :day_subscribers, :day_fb_likes, :day_twitter_followers,
                  :day_plus_followers, :day_tumblr_followers, :day_instagram_followers

  belongs_to :channel

  class << self
    def avg_30_days(date = DateUtil.today)
      Status.where(:report_date => date - 30.days .. date).
        select('avg(day_avg_views) as day_avg_views').
        select('avg(day_vscr) as day_vscr').
        select('avg(day_avg_view_duration) as day_avg_view_duration').
        select('avg(day_views) as day_views').
        select('avg(day_minutes_watched) as day_minutes_watched').
        select('avg(day_subscribers) as day_subscribers').
        select('avg(day_fb_likes) as day_fb_likes').
        select('avg(day_twitter_followers) as day_twitter_followers').
        select('avg(day_plus_followers) as day_plus_followers').
        select('avg(day_tumblr_followers) as day_tumblr_followers').
        select('avg(day_instagram_followers) as day_instagram_followers')
    end
  end
end

