class AddChannelIdToVideoModel < ActiveRecord::Migration
  def change
  	add_column :videos, :channel_id, :integer
  end
end
