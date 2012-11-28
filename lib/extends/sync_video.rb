class SyncVideo

  class << self
    def import_videos
      Channel.find_each() do |p|
        Sync.sync_videos(p)
      end
    end

    def import_detail_videos
      Channel.find_each() do |channel|
        client = GoogleApiClient.youtube_analytics_client channel.username
	      analytics  = client.discovered_api('youtubeAnalytics','v1')
        channel.videos.find_each do |v|
          Sync.sync_detail_video(client, analytics, v)
        end
      end
    end

    def track_videos
      Channel.find_each() do |p|
        DayVideoTracker.track p
      end
      DayVideoGroupTracker.track
    end
  end
end

