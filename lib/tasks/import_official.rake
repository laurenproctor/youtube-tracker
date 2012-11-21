task :import_official => :environment do

  p = Channel.find_by_username 'officialcomedy'
  Sync.sync_videos(p)
  p.videos.find_each do |v|
    Sync.sync_detail_video(v)
  end
end

