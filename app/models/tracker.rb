class Tracker < ActiveRecord::Base
  attr_accessible :comments, :last_week_rank, :name, :weekly_percent_views, :shares, :this_week_rank, :uploaded_at
  attr_accessible :this_week_views, :time_since_upload, :total_aggregate_views, :type,
                  :unique_id, :weeks_on_chart, :trackable_id,
                  :comments, :shares, :tracked_date, :videos_in_series, :trackable, :channel_name,
                  :video_id, :report_date, :percent_change_views, :report_date_wday, :peak_position

  belongs_to :trackable, :polymorphic => true

end

