namespace :db do
  task :update_db => :environment do
    channel = Channel.find_by_username('officialcomedy')
    Video.find_each() do |p|
      unless p.channel_id
        p.channel_id = channel.id
        p.save
      end
    end
    DayVideoTracker.find_each() do |p|
      video = Video.find_by_unique_id p.unique_id
      p.video_id = video.id
      p.save
    end

    FacebookInfo.find_each() do |p|
      unless p.channel_id
        p.channel_id = channel.id
        p.save
      end
    end

    TwitterInfo.find_each() do |p|
      unless p.channel_id
        p.channel_id = channel.id
        p.save
      end
    end

    channel = Channel.find_by_username('officialcomedy')

    Playlist.find_each() do |p|
      unless p.channel_id
        p.channel_id = channel.id
        p.save
      end
    end
    DayPlaylistTracker.find_each() do |p|
      playlist = Playlist.find_by_unique_id p.unique_id
      p.playlist_id = playlist.id
      p.save
    end

    DayVideoTracker.find_each() do |p|
      p.percent_change_views = p.weekly_percent_views.try(:to_f)
      p.weekly_percent_views = nil
      p.save
    end

    DayPlaylistTracker.find_each() do |p|
      p.percent_change_views = p.weekly_percent_views.try(:to_f)
      p.weekly_percent_views = nil
      p.save
    end
  end

end

