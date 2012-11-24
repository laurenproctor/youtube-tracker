class AddReportDateToPlaylistVideos < ActiveRecord::Migration
  def change
    add_column :playlist_videos, :report_date, :date
  end
end
