namespace :db do
  task :import_playlist_video_uploaded_at => :environment do
    PlaylistVideo.find_each() do |p|
      begin
        video = YoutubeClient.youtube_client.video_by(p.video_unique_id)
      rescue
        puts "exception at video unique_id #{p.video_unique_id}"
        next
      end
      p.published_at = video.published_at
      p.uploaded_at = video.uploaded_at
      p.save
    end

  end
end

