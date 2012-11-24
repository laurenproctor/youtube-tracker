class AddReportDateToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :report_date, :date
  end
end
