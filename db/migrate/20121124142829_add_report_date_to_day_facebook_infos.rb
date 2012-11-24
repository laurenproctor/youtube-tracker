class AddReportDateToDayFacebookInfos < ActiveRecord::Migration
  def change
    add_column :day_facebook_infos, :report_date, :date
  end
end
