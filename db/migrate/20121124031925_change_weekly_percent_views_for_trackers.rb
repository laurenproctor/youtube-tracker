class ChangeWeeklyPercentViewsForTrackers < ActiveRecord::Migration
  def change
    change_table :trackers do |t|
      t.change :weekly_percent_views, :decimal, :precision => 10, :scale => 4
    end
  end
end

