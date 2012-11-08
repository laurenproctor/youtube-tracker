class Tracker < ActiveRecord::Base
  attr_accessible :comments, :last_week_rank, :name, :weekly_percent_views, :shares, :this_week_rank, :uploaded_at
  attr_accessible :this_week_views, :time_since_upload, :total_aggregate_views, :type, :unique_id, :weeks_on_chart

  def self.youtube_client
    @yt_client ||= YouTubeIt::Client.new(:dev_key => YOUTUBE[:dev_key])
  end
end

