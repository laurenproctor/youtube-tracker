class AddReportDateToDayVideoModel < ActiveRecord::Migration
  def change
  	add_column :day_videos, :report_date, :date
  end
end
