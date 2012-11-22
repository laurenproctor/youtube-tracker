class ImportVideoJob
  def perform

    begin
      SyncVideo.import_videos

      SyncVideo.import_detail_videos
      SyncVideo.track_videos
      SyncPlaylist.track_playlists
    rescue Exception => e
      failure = true
      error_msg = "#{Time.now} ERROR (ImportJob#perform): #{e.message} - (#{e.class})\n#{(e.backtrace or []).join("\n")}"
      puts error_msg
    ensure
      if failure
        Delayed::Job.enqueue ImportVideoJob.new, 2, Time.now + 20.minutes
      end

    end
  end
end

