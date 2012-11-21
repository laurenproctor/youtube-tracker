task :import_look => :environment do

    p = Channel.find_by_username 'look'
    Sync.sync_videos(p)
    p.videos.find_each do |v|
      Sync.sync_detail_video(v)
    end
end

