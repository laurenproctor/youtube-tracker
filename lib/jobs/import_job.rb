class ImportJob
  def perform

    begin
      SyncChannel.import_channels
      SyncFacebookInfo.import_facebook_infos
      SyncTwitterInfo.import_twitter_infos

      SyncStatus.import_statuses
      SyncPlaylist.import_playlists
      Delayed::Job.enqueue ImportVideoJob.new
    rescue Exception => e
      failure = true
      error_msg = "#{TimeUtil.now} ERROR (ImportJob#perform): #{e.message} - (#{e.class})\n#{(e.backtrace or []).join("\n")}"
      puts error_msg
    ensure
      if failure
        Delayed::Job.enqueue ImportJob.new, 2, TimeUtil.now + 20.minutes
      else
        Delayed::Job.enqueue ImportJob.new, 2, TimeUtil.today + 1.day + 30.minutes
      end

    end
  end
end

