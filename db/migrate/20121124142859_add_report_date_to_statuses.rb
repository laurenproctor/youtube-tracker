class AddReportDateToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :report_date, :date
  end
end
