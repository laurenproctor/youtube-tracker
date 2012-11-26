class AddDayColumnsToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :day_avg_views, :decimal, :precision => 10, :scale => 4
    add_column :statuses, :day_avg_view_duration, :decimal, :precision => 10, :scale => 4
    add_column :statuses, :day_vscr, :decimal, :precision => 10, :scale => 4
    add_column :statuses, :day_views, :decimal
    add_column :statuses, :day_minutes_watched, :decimal
    add_column :statuses, :day_subscribers, :decimal
    add_column :statuses, :day_fb_likes, :integer
    add_column :statuses, :day_twitter_followers, :integer
    add_column :statuses, :day_plus_followers, :integer
    add_column :statuses, :day_tumblr_followers, :integer
    add_column :statuses, :day_instagram_followers, :integer
  end
end

