class ImportJob
  def perform
    begin
       Channel.search_import

       Video.search_import
       DayVideoTracker.track

       Playlist.search_import
       DayPlaylistTracker.track
    rescue Exception => e
      error_msg = "#{Time.now} ERROR (ImportJob#perform): #{e.message} - (#{e.class})\n#{(e.backtrace or []).join("\n")}"
      puts error_msg
    ensure
      Delayed::Job.enqueue ImportJob.new, 2, Time.now.beginning_of_day + 1.day + 30.minutes
    end
  end
end

