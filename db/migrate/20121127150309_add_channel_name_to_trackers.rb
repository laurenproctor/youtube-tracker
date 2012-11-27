class AddChannelNameToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :channel_name, :string
  end
end
