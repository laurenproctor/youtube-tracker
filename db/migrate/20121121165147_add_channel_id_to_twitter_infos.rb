class AddChannelIdToTwitterInfos < ActiveRecord::Migration
  def change
    add_column :twitter_infos, :channel_id, :integer
  end
end
