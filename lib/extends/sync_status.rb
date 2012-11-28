class SyncStatus

  class << self
    def import_statuses(today = TimeUtil.today)
      Channel.find_each() do |channel|

        unless day_channel = channel.day_channels.find_by_unique_id_and_imported_date(channel.unique_id, today)
          next
        end
        twitter_followers = JSON.parse(open(TWITTER[:api_url] +
          TWITTER[channel.username.to_sym][:user_id]).read)['followers_count']
        facebook_likes    = JSON.parse(open(FACEBOOK[:api_url] +
          FACEBOOK[channel.username.to_sym][:user_id]).read)[FACEBOOK[channel.username.to_sym][:user_id]]['likes']

        plus_followers = JSON.parse(open("#{GOOGLE[:api_url]}/#{GOOGLE[channel.username.to_sym][:user_id]}?key=#{GOOGLE[channel.username.to_sym][:api_key]}").read)['plusOneCount']
        client = GoogleApiClient.youtube_analytics_client channel.username
        analytics  = client.discovered_api('youtubeAnalytics','v1')
        startDate  = (day_channel.channel.join_date - 7.days).strftime("%Y-%m-%d")
        endDate    = TimeUtil.today.strftime("%Y-%m-%d")
        channelId  = YOUTUBE[channel.username.to_sym][:channel_id]
        lifetime_views, subscribersGained = views_subscribers(client, analytics, channelId, startDate, endDate)
        averageViewDuration = avg_view_duration(client, analytics, channelId, startDate, endDate)
        estimatedMinutesWatched = estimated_minutes_watched(client, analytics, channelId, startDate, endDate)
        yesterday_status = channel.statuses.find_by_imported_date(today - 1.day)
        params = { :channel_id => channel.id, :imported_date => today, :user_id => channel.username,
                   :report_date => today - 1.day,
                   :avg_view_duration => averageViewDuration, :minutes_watched => estimatedMinutesWatched,
                   :lifetime_views => lifetime_views, :subscribers => subscribersGained,
                   :fb_likes => facebook_likes, :instagram_followers => nil, :tumblr_followers => nil,
                   :twitter_followers => twitter_followers, :plus_followers => plus_followers,
                   :day_avg_views => 0,
                   :day_avg_view_duration => 0,
                   :day_vscr  => 0,
                   :day_views => 0,
                   :day_minutes_watched => 0,
                   :day_subscribers => 0,
                   :day_fb_likes => 0,
                   :day_twitter_followers => 0,
                   :day_plus_followers => 0
        }
        params[:avg_views] = params[:lifetime_views] / day_channel.upload_count if day_channel.upload_count > 0
        params[:vscr] = subscribersGained * 100.0 / lifetime_views if lifetime_views > 0

        unless status = channel.statuses.find_by_imported_date(today)
          status = Status.create params
        else
          status.update_attributes params
        end
        if yesterday_status
          attrs = {
            :day_avg_views => (status.avg_views - yesterday_status.avg_views),
            :day_avg_view_duration => (status.avg_view_duration -
               yesterday_status.avg_view_duration) ,
            :day_vscr => (status.vscr - yesterday_status.vscr),
            :day_views => (status.lifetime_views - yesterday_status.lifetime_views),
            :day_minutes_watched => (status.minutes_watched - yesterday_status.minutes_watched),
            :day_subscribers => (status.subscribers - yesterday_status.subscribers),
            :day_fb_likes => (status.fb_likes - yesterday_status.fb_likes),
            :day_twitter_followers => (status.twitter_followers -
               yesterday_status.twitter_followers),
            :day_plus_followers => (status.plus_followers - yesterday_status.plus_followers)
          }
          status.update_attributes attrs
        end
      end
    end

    private
      def views_subscribers (client, analytics, channelId, startDate, endDate)
        visitCount = client.execute(:api_method => analytics.reports.query, :parameters => {
          'start-date' => startDate,
          'end-date' => endDate,
          ids: 'channel==' + channelId,
          metrics: 'views,subscribersGained'
        })
        lifetime_views    = 0
        subscribersGained = 0

        visitCount.data.rows.each do |r|
          lifetime_views += r[0]
          subscribersGained += r[1]
        end
        return lifetime_views, subscribersGained
      end

      def avg_view_duration (client, analytics, channelId, startDate, endDate)
        visitCount = client.execute(:api_method => analytics.reports.query, :parameters => {
          'start-date' => startDate,
          'end-date' => endDate,
          ids: 'channel==' + channelId,
          # dimensions: 'day',
          metrics: 'averageViewDuration'
        })
        averageViewDuration = 0
        visitCount.data.rows.each do |r|
          averageViewDuration += r[0]
        end
        return averageViewDuration
      end

      def estimated_minutes_watched (client, analytics, channelId, startDate, endDate)
        visitCount = client.execute(:api_method => analytics.reports.query, :parameters => {
          'start-date' => startDate,
          'end-date' => endDate,
          ids: 'channel==' + channelId,
          metrics: 'estimatedMinutesWatched'
        })
        estimatedMinutesWatched = 0

        visitCount.data.rows.each do |r|
          estimatedMinutesWatched += r[0]
        end
        return estimatedMinutesWatched
      end
  end
end

