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
    @channel = Channel.find_by_username YOUTUBE[:user_id]
    @top_videos = DayVideoTracker.top(today).order('this_week_rank asc')

    seven_days = Time.now - 7.days .. Time.now

    subscribers_chart seven_days

    avg_views_chart seven_days

    facebook_info_chart seven_days

    twitter_info_chart seven_days

    config = YOUTUBE_ANALYTICS[:NetworkA]
    client = Google::APIClient.new

    # Request authorization
    client.authorization.client_id = config[:client_id]
    client.authorization.client_secret = config[:client_secret]
    client.authorization.scope = OAUTH_SCOPE
    client.authorization.redirect_uri = config[:redirect_uri]

    #uri = client.authorization.authorization_uri

    client.authorization.refresh_token = config[:authorization_refresh_token]
    client.authorization.code = config[:authorization_code]

    begin
      client.authorization.fetch_access_token!
    rescue
      data = {
        :client_id => config[:client_id],
        :client_secret => config[:client_secret],
        :refresh_token => client.authorization.refresh_token,
        :grant_type => "refresh_token"
      }
      response = JSON.parse(RestClient.post "https://accounts.google.com/o/oauth2/token", data)
      client.authorization.access_token = response["access_token"]
    end

    analytics  = client.discovered_api('youtubeAnalytics','v1')
    startDate  = '2006-01-01'  # DateTime.now.prev_month.strftime("%Y-%m-%d")
    endDate    = '2013-01-01' # DateTime.now.strftime("%Y-%m-%d")
    channelId  = 'UCsert8exifX1uUnqaoY3dqA'
    videoId    = 'CFu4htAIoBI'
    visitCount = client.execute(:api_method => analytics.reports.query, :parameters => {
      'start-date' => startDate,
      'end-date' => endDate,
      ids: 'channel==' + channelId,
      dimensions: 'day',
      metrics: 'views,subscribersGained'
      # filters: 'video==' + videoId
    })
    @twitter_followers = JSON.parse(open(TWITTER[:api_url] + TWITTER[:NetworkA][:user_id]).read)['followers_count']
    @facebook_likes    = JSON.parse(open(FACEBOOK[:api_url] + FACEBOOK[:NetworkA][:user_id]).read)[FACEBOOK[:NetworkA][:user_id]]['likes']

    @plus_followers = JSON.parse(open("#{GOOGLE[:api_url]}/#{GOOGLE[:NetworkA][:user_id]}?key=#{GOOGLE[:NetworkA][:api_key]}").read)['plusOneCount']

    @lifetime_views    = 0
    @subscribersGained = 0
    print visitCount.data.column_headers.map { |c|
      c.name
    }.join("\t")
    puts "-----------------"
    visitCount.data.rows.each do |r|
      print r.join("\t"), "\n"
      @lifetime_views += r[1]
      @subscribersGained += r[2]
    end

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

