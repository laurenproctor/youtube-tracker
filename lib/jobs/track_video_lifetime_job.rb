class TrackVideoLifetimeJob  < Struct.new(:from_date, :to_date)
  def perform

    begin
      Channel.find_each() do |channel|
        dates = channel.day_videos.order('report_date asc').map(&:report_date).uniq
        dates.each do |date|
          DayVideoTracker.track_at_date(channel, date) if date <= to_date && date >= from_date
        end
      end
    rescue Exception => e
      failure = true
      error_msg = "#{Time.now} ERROR (Job#perform): #{e.message} - (#{e.class})\n#{(e.backtrace or []).join("\n")}"
      puts error_msg
    ensure
      if failure
        Delayed::Job.enqueue TrackVideoLifetimeJob.new(from_date, to_date), 2, Time.now + 20.minutes
      end

    end
  end
end

