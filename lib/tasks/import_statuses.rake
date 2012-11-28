task :import_statuses => :environment do
  today = TimeUtil.today
  %w(officialcomedy networka look).each do |p|
    Channel.search_import YOUTUBE[p.to_sym][:user_id]
  end
  %w(officialcomedy networka look).each do |p|
    channel = p.to_sym
    unless day_channel = DayChannel.find_by_unique_id_and_imported_date(YOUTUBE[channel][:user_unique], today)
      next
    end
    twitter_followers = JSON.parse(open(TWITTER[:api_url] + TWITTER[channel.to_sym][:user_id]).read)['followers_count']
    facebook_likes    = JSON.parse(open(FACEBOOK[:api_url] + FACEBOOK[channel.to_sym][:user_id]).read)[FACEBOOK[channel.to_sym][:user_id]]['likes']

    plus_followers = JSON.parse(open("#{GOOGLE[:api_url]}/#{GOOGLE[channel.to_sym][:user_id]}?key=#{GOOGLE[channel.to_sym][:api_key]}").read)['plusOneCount']
    client = GoogleApiClient.youtube_analytics_client channel
    analytics  = client.discovered_api('youtubeAnalytics','v1')
    startDate  = day_channel.channel.join_date.strftime("%Y-%m-%d")
    endDate    = TimeUtil.now.strftime("%Y-%m-%d")
    channelId  = YOUTUBE[channel.to_sym][:channel_id]
    lifetime_views, subscribersGained = views_subscribers(client, analytics, channelId, startDate, endDate)
    averageViewDuration = avg_view_duration(client, analytics, channelId, startDate, endDate)
    estimatedMinutesWatched = estimated_minutes_watched(client, analytics, channelId, startDate, endDate)

    params = { :imported_date => today, :user_id => channel,:report_date => today - 1.day,
               :avg_view_duration => averageViewDuration, :minutes_watched => estimatedMinutesWatched,
               :lifetime_views => lifetime_views, :subscribers => subscribersGained,
               :fb_likes => facebook_likes, :instagram_followers => nil, :tumblr_followers => nil,
               :twitter_followers => twitter_followers, :plus_followers => plus_followers
    }
    params[:avg_views] = params[:lifetime_views] / day_channel.upload_count if day_channel.upload_count > 0
    params[:vscr] = subscribersGained * 100.0 / lifetime_views if lifetime_views > 0

    unless status = Status.find_by_user_id_and_imported_date(params[:user_id], today)
      Status.create params
    else
      status.update_attributes params
    end
  end
end

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
    metrics: 'estimatedMinutesWatched'
  })
  estimatedMinutesWatched = 0

  visitCount.data.rows.each do |r|
    estimatedMinutesWatched += r[0]
  end
  return estimatedMinutesWatched
end

