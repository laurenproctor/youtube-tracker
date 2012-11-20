class AddJoinDateToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :join_date, :datetime
  end
end
