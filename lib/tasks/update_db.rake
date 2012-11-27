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
      unless p.percent_change_views
        p.percent_change_views = p.weekly_percent_views.try(:to_f)
        p.weekly_percent_views = nil
        p.save
      end
    end

    DayPlaylistTracker.find_each() do |p|
      unless p.percent_change_views
        p.percent_change_views = p.weekly_percent_views.try(:to_f)
        p.weekly_percent_views = nil
        p.save
      end
    end

    Channel.find_each() do |channel|
      statuses = channel.statuses.order(:report_date)
      statuses.each_with_index do |p, index|
        unless p.day_views
          attrs = {
            :day_avg_views => index == 0 ? 0 : (statuses[index].avg_views - statuses[index - 1].avg_views),
            :day_avg_view_duration => index == 0 ? 0 : (statuses[index].avg_view_duration - statuses[index - 1].avg_view_duration) ,
            :day_vscr => index == 0 ? 0 : (statuses[index].vscr - statuses[index - 1].vscr),
            :day_views => index == 0 ? 0 : (statuses[index].lifetime_views - statuses[index - 1].lifetime_views),
            :day_minutes_watched => index == 0 ? 0 : (statuses[index].minutes_watched - statuses[index - 1].minutes_watched),
            :day_subscribers => index == 0 ? 0 : (statuses[index].subscribers - statuses[index - 1].subscribers),
            :day_fb_likes => index == 0 ? 0 : (statuses[index].fb_likes - statuses[index - 1].fb_likes),
            :day_twitter_followers => index == 0 ? 0 : (statuses[index].twitter_followers - statuses[index - 1].twitter_followers),
            :day_plus_followers => index == 0 ? 0 : (statuses[index].plus_followers - statuses[index - 1].plus_followers)
          }
          p.update_attributes attrs
        end
      end
    end

  end

end

