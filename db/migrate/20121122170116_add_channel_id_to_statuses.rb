class AddChannelIdToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :channel_id, :integer
  end
end
