class CreateDayTwitterInfos < ActiveRecord::Migration
  def change
    create_table :day_twitter_infos do |t|
      t.integer :twitter_info_id
      t.string :unique_id
      t.datetime :imported_date
      t.integer :followers_count
      t.integer :friends_count
      t.integer :listed_count
      t.integer :favourites_count
      t.integer :statuses_count

      t.timestamps
    end
    add_index :day_twitter_infos, :twitter_info_id
    add_index :day_twitter_infos, :imported_date
    add_index :day_twitter_infos, :unique_id
  end
end

