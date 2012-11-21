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
  end

end

