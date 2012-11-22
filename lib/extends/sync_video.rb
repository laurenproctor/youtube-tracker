class SyncVideo

  class << self
    def import_videos
      Channel.find_each() do |p|
        Sync.sync_videos(p)
      end
    end

    def import_detail_videos
      Channel.find_each() do |p|
        p.videos.find_each do |v|
          Sync.sync_detail_video(v)
        end
      end
    end

    def track_videos
      Channel.find_each() do |p|
        DayVideoTracker.track p
      end
    end
  end
end

