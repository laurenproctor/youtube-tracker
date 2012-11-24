class AddEngagementMetricsToDayVideos < ActiveRecord::Migration
  def change
    add_column :day_videos, :day_comments, :integer
    add_column :day_videos, :day_favorites_added, :integer
    add_column :day_videos, :day_favorites_removed, :integer
    add_column :day_videos, :day_likes, :integer
    add_column :day_videos, :day_dislikes, :integer
    add_column :day_videos, :day_shares, :integer
    add_column :day_videos, :day_subscribers_gained, :integer
    add_column :day_videos, :day_subscribers_lost, :integer
    add_column :day_videos, :week_views, :integer
    add_column :day_videos, :report_date_wday, :integer
  end
end
