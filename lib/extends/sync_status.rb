class SyncStatus

  class << self
    def import_statuses(today = Date.today.to_datetime)
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
        startDate  = day_channel.channel.join_date.strftime("%Y-%m-%d")
        endDate    = Time.now.strftime("%Y-%m-%d")
        channelId  = YOUTUBE[channel.username.to_sym][:channel_id]
        lifetime_views, subscribersGained = views_subscribers(client, analytics, channelId, startDate, endDate)
        averageViewDuration = avg_view_duration(client, analytics, channelId, startDate, endDate)
        estimatedMinutesWatched = estimated_minutes_watched(client, analytics, channelId, startDate, endDate)

        params = { :imported_date => today, :user_id => channel.username,
                   :avg_view_duration => averageViewDuration, :minutes_watched => estimatedMinutesWatched,
                   :lifetime_views => lifetime_views, :subscribers => subscribersGained,
                   :fb_likes => facebook_likes, :instagram_followers => nil, :tumblr_followers => nil,
                   :twitter_followers => twitter_followers, :plus_followers => plus_followers
        }
        params[:avg_views] = params[:lifetime_views] / day_channel.upload_count if day_channel.upload_count > 0
        params[:vscr] = subscribersGained * 100.0 / lifetime_views if lifetime_views > 0

        unless status = channel.statuses.find_by_imported_date(today)
          Status.create params
        else
          status.update_attributes params
        end
      end
    end

    private
      def views_subscribers (client, analytics, channelId, startDate, endDate)
        visitCount = client.execute(:api_method => analytics.reports.query, :parameters => {
          'start-date' => startDate,
          'end-date' => endDate,
          ids: 'channel==' + channelId,
          dimensions: 'day',
          metrics: 'views,subscribersGained'
        })
        lifetime_views    = 0
        subscribersGained = 0
        averageViewDuration = 0
        estimatedMinutesWatched = 0
        print visitCount.data.column_headers.map { |c|
          c.name
        }.join("\t")
        visitCount.data.rows.each do |r|
          lifetime_views += r[1]
          subscribersGained += r[2]
        end
        return lifetime_views, subscribersGained
      end

      def avg_view_duration (client, analytics, channelId, startDate, endDate)
        visitCount = client.execute(:api_method => analytics.reports.query, :parameters => {
          'start-date' => startDate,
          'end-date' => endDate,
          ids: 'channel==' + channelId,
          dimensions: 'day',
          metrics: 'averageViewDuration'
        })
        averageViewDuration = 0
        visitCount.data.rows.each do |r|
          averageViewDuration += r[1]
        end
        return averageViewDuration
      end

      def estimated_minutes_watched (client, analytics, channelId, startDate, endDate)
        visitCount = client.execute(:api_method => analytics.reports.query, :parameters => {
          'start-date' => startDate,
          'end-date' => endDate,
          ids: 'channel==' + channelId,
          dimensions: 'day',
          metrics: 'estimatedMinutesWatched'
        })
        estimatedMinutesWatched = 0

        visitCount.data.rows.each do |r|
          estimatedMinutesWatched += r[1]
        end
        return estimatedMinutesWatched
      end
  end
end

