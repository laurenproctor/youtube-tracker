class HomeController < ApplicationController
  def index
    today = Time.now.beginning_of_day
    @channel = Channel.find_by_username(YOUTUBE[:user_id])
    @top_videos = DayVideoTracker.where(:this_week_rank => 1 .. 25, :tracked_date => today).
      order(sort_column(DayVideoTracker) + " " + sort_direction).limit(25) # .page(params[:page])

    @top_playlists = DayPlaylistTracker.where(:this_week_rank => 1 .. 25, :tracked_date => today).
      order(sort_column(DayPlaylistTracker) + " " + sort_direction).limit(25)

    seven_days = Time.now - 7.days .. Time.now
    last_week_seven_days = Time.now - 14.days .. Time.now - 7.days
    rows = DayChannel.where(:imported_date => seven_days)
    last_week_rows = DayChannel.where(:imported_date => last_week_seven_days)
    @subscribers = {}
    @keys = []
    rows.each do |p|
      key = p.imported_date.strftime('%m/%d')
      @subscribers.merge!( key => p.subscribers )
      @keys << key
    end

    avg_views_rows=DayVideo.where(:imported_date => seven_days).select('imported_date, avg(day_view_count) as day_view_count').group(:imported_date)
    last_week_avg_views_rows=DayVideo.where(:imported_date => last_week_seven_days).select('imported_date, avg(day_view_count) as day_view_count').group(:imported_date)
    @avg_views_json = {}
    @avg_views_keys = []
    avg_views_rows.each do |p|
      key = p[:imported_date].strftime('%m/%d')
      @avg_views_json.merge!( key => p[:day_view_count] )
      @avg_views_keys << key
    end

    facebook_info_rows = DayFacebookInfo.where(:imported_date => seven_days)
    last_week_facebook_info_rows = DayFacebookInfo.where(:imported_date => last_week_seven_days)
    @facebook_info_json = {}
    @facebook_info_keys = []
    @facebook_likes_json = {}
    facebook_info_rows.each do |p|
      key = p.imported_date.strftime('%m/%d')
      @facebook_info_json.merge!( key => p.talking_about_count )
      @facebook_likes_json.merge!( key => p.likes )
      @facebook_info_keys << key
    end

    twitter_info_rows = DayTwitterInfo.where(:imported_date => seven_days)
    last_week_twitter_info_rows = DayTwitterInfo.where(:imported_date => last_week_seven_days)
    @twitter_info_json = {}
    @twitter_info_keys = []
    facebook_info_rows.each do |p|
      key = p.imported_date.strftime('%m/%d')
      @twitter_info_json.merge!( key => p.likes )
      @twitter_info_keys << key
    end
  end
end

