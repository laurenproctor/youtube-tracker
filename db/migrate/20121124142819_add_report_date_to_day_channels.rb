class AddReportDateToDayChannels < ActiveRecord::Migration
  def change
    add_column :day_channels, :report_date, :date
  end
end
