class CreateTwitterInfos < ActiveRecord::Migration
  def change
    create_table :twitter_infos do |t|
      t.string :unique_id
      t.string :screen_name
      t.string :name
      t.string :location
      t.string :url
      t.text :description

      t.timestamps
    end
    add_index :twitter_infos, :screen_name
    add_index :twitter_infos, :unique_id
  end
end

