class HomeController < ApplicationController

  def index
    render :layout => false
  end

  def bedrocket
    today = TimeUtil.today - 1.day
    params[:user_id] = 'officialcomedy' unless params[:user_id]

    @channel = Channel.find_by_username YOUTUBE[params[:user_id].to_sym][:user_id].downcase
    params[:sort] = 'this_week_rank' unless params[:sort]
    direction = sort_direction
    if params[:sort] == 'uploaded_at'
      if direction == "asc"
        direction = "desc"
      else
        direction = "asc"
      end
    end
    @top_videos = DayVideoGroupTracker.
    where(:this_week_rank => 1 .. 25, :report_date => today - 3.day .. today).
    order('report_date desc ').limit(25).
    order(sort_column(DayVideoGroupTracker, 'this_week_rank') + " " + direction)

  end

  def channel
    today = TimeUtil.today - 1.day
    params[:user_id] = 'officialcomedy' unless params[:user_id]

    @channel = Channel.find_by_username YOUTUBE[params[:user_id].to_sym][:user_id].downcase
    @goal = @channel.goal
    params[:sort] = 'this_week_rank' unless params[:sort]
    direction = sort_direction
    if params[:sort] == 'uploaded_at'
      if direction == "asc"
        direction = "desc"
      else
        direction = "asc"
      end
    end
    @top_videos = @channel.day_video_trackers.
    where(:this_week_rank => 1 .. 25, :report_date => today - 3.day .. today).
    order('report_date desc ').limit(25).
    order(sort_column(DayVideoTracker, 'this_week_rank') + " " + direction)

    @top_in_day = @channel.day_videos.
      where(:report_date => today.beginning_of_week .. today).
      order('day_view_count desc').first

    seven_days = TimeUtil.today - 7.days .. TimeUtil.today

    subscribers_chart seven_days

    avg_views_chart seven_days

    facebook_info_chart seven_days

    twitter_info_chart seven_days

    @status = @channel.statuses.where(:report_date => today - 1.day .. today).order('created_at desc').first
    @avg_last_30 = @channel.statuses.avg_30_days(DateUtil.today).first
=begin
    begin
      client = YoutubeClient.youtube_client(@channel.username)
      @top_video = client.videos_by(:user => @channel.username, :page => 1,
        :max_results => 1, :order_by => 'viewCount').videos.first
    rescue Exception => e
      logger.info e.message
    end
=end
  end

  def export_csv
    to = params[:to].try(:to_date) unless  params[:to_copy].blank?
    from = params[:from].try(:to_date)  unless  params[:from_copy].blank?
    if to && from
      @filename = "export-csv-#{ from.strftime('%Y-%m-%d')}-#{ to.strftime('%Y-%m-%d')}.csv"
    elsif from
      @filename = "export-csv-#{ from.strftime('%Y-%m-%d')}.csv"
    elsif to
      @filename = "export-csv-#{ to.strftime('%Y-%m-%d')}.csv"
    else
      @filename = "export-csv.csv"
    end

    if params[:type] == 'Video'
      export_csv_videos  from, to
    elsif params[:type] == 'Playlist'
      export_csv_playlists  from, to
    elsif params[:type] == 'Channel'
      export_csv_channel from, to
    end
  end

  def setting
    @channel = Channel.find_by_username params[:username]

    if @channel && params[:password] == 'jSw9lMzS' && params[:time_left]
      attrs = {
        :facebook_likes => params[:facebook_likes] || 0,
        :subscribers    => params[:subscribers] || 0,
        :time_left_days => params[:time_left_days] || 0,
        :time_target    => params[:time_left].to_date,
        :view_time      => params[:view_time] || 0,
        :views          => params[:views] || 0,
        :channel_id => @channel.id
      }
      attrs[:time_left_days] = (params[:time_left].to_date - DateUtil.today).to_i

      unless @goal = @channel.goal
        @goal = Goal.create attrs
      else
        @goal.update_attributes attrs
      end
    end
  end

  private

    def export_csv_channel from, to
      if to && from
        @day_channels = DayChannel.where('report_date >= ? AND report_date <= ?', from, to)
      elsif from
        @day_channels = DayChannel.where('report_date >= ?', from)
      elsif to
        @day_channels = DayChannel.where('report_date <= ?', to)
      else
        @day_channels = DayChannel.where('id > 0')
      end
      @day_channels = @day_channels.order(:report_date)

      respond_to do |format|
        format.csv { render 'export_csv_channel' }
      end
    end


    def export_csv_playlists from, to
      if to && from
        @playlists = Playlist.where('published_at >= ? AND published_at <= ?', from, to)
      elsif from
        @playlists = Playlist.where('published_at >= ?', from)
      elsif to
        @playlists = Playlist.where('published_at <= ?', to)
      else
        @playlists = Playlist.where('id > 0')
      end
      @playlists = @playlists.order(:title)
      respond_to do |format|
        format.csv { render 'export_csv_playlist' }
      end
    end

    def export_csv_videos from, to
      if to && from
        @videos = Video.where('uploaded_at >= ? AND uploaded_at <= ?', from, to)
      elsif from
        @videos = Video.where('uploaded_at >= ?', from)
      elsif to
        @videos = Video.where('uploaded_at <= ?', to)
      else
        @videos = Video.where('id > 0')
      end
      @videos = @videos.order(:title)
      respond_to do |format|
        format.csv { render 'export_csv' }
      end
    end

    def subscribers_chart days_range
      rows = @channel.day_channels.where(:report_date => days_range).order('report_date')
      @subscribers = {}
      @last_week_subscribers = {}
      @keys = []
      rows.each do |p|
        key = p.report_date.strftime('%m/%d')
        @subscribers.merge!( key => p.subscribers )
        if at_last_7_days = @channel.day_channels.where(:report_date => p.report_date - 7.days).first
          @last_week_subscribers.merge!( key => at_last_7_days.subscribers )
        end
        @keys << key
      end
    end

    def avg_views_chart days_range
      avg_views_rows=DayVideo.joins(:video).where('videos.channel_id =?', @channel.id).
        where(:report_date => days_range).
        select('report_date, avg(view_count) as view_count').order('report_date').group(:report_date)
      @avg_views_json = {}
      @last_week_avg_views_json = {}
      @avg_views_keys = []
      avg_views_rows.each do |p|
        key = p[:report_date].strftime('%m/%d')
        @avg_views_json.merge!( key => p[:view_count] )
        if at_last_7_days = DayVideo.joins(:video).where('videos.channel_id =?', @channel.id).
            where(:report_date => p[:report_date] - 7.days).
            select('avg(view_count) as view_count').first
          @last_week_avg_views_json.merge!( key => at_last_7_days[:view_count] )
        end
        @avg_views_keys << key
      end
    end

    def facebook_info_chart days_range
      facebook_info_rows = DayFacebookInfo.joins(:facebook_info).where('facebook_infos.channel_id =?', @channel.id).
        where(:report_date => days_range).order('report_date')
      @facebook_info_json = {}
      @facebook_info_keys = []
      @facebook_likes_json = {}
      facebook_info_rows.each do |p|
        key = p.report_date.strftime('%m/%d')
        @facebook_info_json.merge!( key => p.talking_about_count )
        @facebook_likes_json.merge!( key => p.likes )
        @facebook_info_keys << key
      end
    end

    def twitter_info_chart days_range
      twitter_info_rows = DayTwitterInfo.joins(:twitter_info).where('twitter_infos.channel_id =?', @channel.id).where(:report_date => days_range).order('report_date')
      @twitter_info_json = {}
      @last_week_twitter_info_json = {}
      @twitter_info_keys = []
      twitter_info_rows.each do |p|
        key = p.report_date.strftime('%m/%d')
        @twitter_info_json.merge!( key => p.followers_count )
        if at_last_7_days = DayTwitterInfo.where(:report_date => p.report_date - 7.days).first
          @last_week_twitter_info_json.merge!( key => at_last_7_days.followers_count )
        end
        @twitter_info_keys << key

      end
    end

end

