class AddChannelIdToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :channel_id, :integer
  end
end
