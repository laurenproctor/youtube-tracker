class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :username
      t.string :username_display
      t.string :unique_id
      t.string :location
      t.string :avatar

      t.timestamps
    end
    add_index :channels, :username
    add_index :channels, :unique_id
  end
end

