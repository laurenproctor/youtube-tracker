class AddReportDateToDayPlaylists < ActiveRecord::Migration
  def change
    add_column :day_playlists, :report_date, :date
  end
end
