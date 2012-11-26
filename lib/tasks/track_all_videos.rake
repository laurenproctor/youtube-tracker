task :track_all_videos => :environment do
  Channel.find_each() do |channel|
    dates = channel.day_videos.order('report_date asc').map(&:report_date).uniq
    dates.each do |date|
      DayVideoTracker.track_at_date(channel, date)
    end
  end
end

