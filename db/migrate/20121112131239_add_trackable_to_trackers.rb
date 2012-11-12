class AddTrackableToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :trackable_type, :string
    add_column :trackers, :trackable_id, :integer
  end
end
