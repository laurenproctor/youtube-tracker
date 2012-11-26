class AddReportDateWdayToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :report_date_wday, :integer
  end
end
