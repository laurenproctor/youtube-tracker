class ChangDataTypeForStatuses < ActiveRecord::Migration
  def change
    change_table :statuses do |t|
      t.change :avg_views, :decimal, :precision => 10, :scale => 4
      t.change :avg_view_duration, :decimal, :precision => 10, :scale => 4
      t.change :vscr, :decimal, :precision => 10, :scale => 4
    end
  end

end

