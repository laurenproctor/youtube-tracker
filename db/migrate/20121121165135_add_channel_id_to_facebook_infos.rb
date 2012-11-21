class AddChannelIdToFacebookInfos < ActiveRecord::Migration
  def change
    add_column :facebook_infos, :channel_id, :integer
  end
end
