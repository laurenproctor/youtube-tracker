class HomeController < ApplicationController

  def index
    today = Time.now.beginning_of_day
    @channel = Channel.find_by_username YOUTUBE[:user_id]
    @top_videos = DayVideoTracker.top(today).order('this_week_rank asc')
    @top_playlists = DayPlaylistTracker.top(today).order('this_week_rank asc')

    seven_days = Time.now - 7.days .. Time.now

    subscribers_chart seven_days

    avg_views_chart seven_days

    facebook_info_chart seven_days

    twitter_info_chart seven_days

  end

  def channel
    today = Time.now.beginning_of_day
    params[:user_id] = 'NetworkA' unless params[:user_id]
    @channel = Channel.find_by_username YOUTUBE[params[:user_id].to_sym][:user_id].downcase
    @top_videos = DayVideoTracker.top(today).order('this_week_rank asc')
    @top_video = @top_videos.first
    @top_in_day = DayVideo.where(:imported_date => today.beginning_of_week .. today).
      order('day_view_count desc').first
    seven_days = Time.now - 7.days .. Time.now

    subscribers_chart seven_days

    avg_views_chart seven_days

    facebook_info_chart seven_days

    twitter_info_chart seven_days

    @status = Status.where(:user_id => params[:user_id], :imported_date => today - 1.day .. today).order('imported_date desc').first
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

  private

    def export_csv_channel from, to
      if to && from
        @day_channels = DayChannel.where('imported_date >= ? AND imported_date <= ?', from, to)
      elsif from
        @day_channels = DayChannel.where('imported_date >= ?', from)
      elsif to
        @day_channels = DayChannel.where('imported_date <= ?', to)
      else
        @day_channels = DayChannel.where('id > 0')
      end
      @day_channels = @day_channels.order(:imported_date)

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
      rows = DayChannel.where(:imported_date => days_range).order('imported_date')
      @subscribers = {}
      @last_week_subscribers = {}
      @keys = []
      rows.each do |p|
        key = p.data_date.strftime('%m/%d')
        @subscribers.merge!( key => p.subscribers )
        if at_last_7_days = DayChannel.where(:imported_date => p.imported_date - 7.days).first
          @last_week_subscribers.merge!( key => at_last_7_days.subscribers )
        end
        @keys << key
      end
    end

    def avg_views_chart days_range
      avg_views_rows=DayVideo.where(:imported_date => days_range).
        select('imported_date, avg(view_count) as view_count').order('imported_date').group(:imported_date)
      @avg_views_json = {}
      @last_week_avg_views_json = {}
      @avg_views_keys = []
      avg_views_rows.each do |p|
        key = (p[:imported_date].getlocal() - 1.day).strftime('%m/%d')
        @avg_views_json.merge!( key => p[:view_count] )
        if at_last_7_days = DayVideo.where(:imported_date => p[:imported_date] - 7.days).
            select('avg(view_count) as view_count').first
          @last_week_avg_views_json.merge!( key => at_last_7_days[:view_count] )
        end
        @avg_views_keys << key
      end
    end

    def facebook_info_chart days_range
      facebook_info_rows = DayFacebookInfo.where(:imported_date => days_range).order('imported_date')
      @facebook_info_json = {}
      @facebook_info_keys = []
      @facebook_likes_json = {}
      facebook_info_rows.each do |p|
        key = p.data_date.strftime('%m/%d')
        @facebook_info_json.merge!( key => p.talking_about_count )
        @facebook_likes_json.merge!( key => p.likes )
        @facebook_info_keys << key
      end
    end

    def twitter_info_chart days_range
      twitter_info_rows = DayTwitterInfo.where(:imported_date => days_range).order('imported_date')
      @twitter_info_json = {}
      @last_week_twitter_info_json = {}
      @twitter_info_keys = []
      twitter_info_rows.each do |p|
        key = p.data_date.strftime('%m/%d')
        @twitter_info_json.merge!( key => p.followers_count )
        if at_last_7_days = DayTwitterInfo.where(:imported_date => p.imported_date - 7.days).first
          @last_week_twitter_info_json.merge!( key => at_last_7_days.followers_count )
        end
        @twitter_info_keys << key

      end
    end

end

