class AddPeakPositionToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :peak_position, :integer
  end
end
