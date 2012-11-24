class AddReportDateToDayTwitterInfos < ActiveRecord::Migration
  def change
    add_column :day_twitter_infos, :report_date, :date
  end
end
