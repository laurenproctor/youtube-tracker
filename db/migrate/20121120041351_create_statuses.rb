class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.decimal :lifetime_views
      t.decimal :avg_views
      t.decimal :minutes_watched
      t.decimal :avg_view_duration
      t.decimal :subscribers
      t.decimal :vscr
      t.integer :fb_likes
      t.integer :twitter_followers
      t.integer :plus_followers
      t.integer :tumblr_followers
      t.integer :instagram_followers
      t.string :user_id
      t.datetime :imported_date

      t.timestamps
    end
  end
end

