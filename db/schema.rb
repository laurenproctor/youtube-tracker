# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121127150309) do

  create_table "channels", :force => true do |t|
    t.string   "username"
    t.string   "username_display"
    t.string   "unique_id"
    t.string   "location"
    t.string   "avatar"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.datetime "join_date"
  end

  add_index "channels", ["unique_id"], :name => "index_channels_on_unique_id"
  add_index "channels", ["username"], :name => "index_channels_on_username"

  create_table "day_channels", :force => true do |t|
    t.integer  "channel_id"
    t.string   "unique_id"
    t.integer  "upload_count"
    t.integer  "subscribers"
    t.integer  "view_count"
    t.integer  "upload_views"
    t.datetime "imported_date"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.date     "report_date"
  end

  add_index "day_channels", ["channel_id"], :name => "index_day_channels_on_channel_id"
  add_index "day_channels", ["imported_date"], :name => "index_day_channels_on_imported_date"
  add_index "day_channels", ["unique_id"], :name => "index_day_channels_on_unique_id"

  create_table "day_facebook_infos", :force => true do |t|
    t.integer  "facebook_info_id"
    t.string   "unique_id"
    t.datetime "imported_date"
    t.integer  "likes"
    t.integer  "talking_about_count"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.date     "report_date"
  end

  add_index "day_facebook_infos", ["facebook_info_id"], :name => "index_day_facebook_infos_on_facebook_info_id"
  add_index "day_facebook_infos", ["imported_date"], :name => "index_day_facebook_infos_on_imported_date"
  add_index "day_facebook_infos", ["unique_id"], :name => "index_day_facebook_infos_on_unique_id"

  create_table "day_playlists", :force => true do |t|
    t.integer  "comment_count"
    t.integer  "day_view_count"
    t.integer  "dislikes"
    t.datetime "imported_date"
    t.integer  "favorite_count"
    t.integer  "likes"
    t.integer  "rater_count"
    t.decimal  "rating_average",   :precision => 28, :scale => 7
    t.string   "unique_id"
    t.integer  "playlist_id"
    t.integer  "view_count"
    t.integer  "video_count"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.text     "video_unique_ids"
    t.date     "report_date"
  end

  add_index "day_playlists", ["day_view_count"], :name => "index_day_playlists_on_day_view_count"
  add_index "day_playlists", ["imported_date"], :name => "index_day_playlists_on_imported_date"
  add_index "day_playlists", ["playlist_id"], :name => "index_day_playlists_on_playlist_id"
  add_index "day_playlists", ["rating_average"], :name => "index_day_playlists_on_rating_average"
  add_index "day_playlists", ["unique_id"], :name => "index_day_playlists_on_unique_id"
  add_index "day_playlists", ["video_count"], :name => "index_day_playlists_on_video_count"
  add_index "day_playlists", ["view_count"], :name => "index_day_playlists_on_view_count"

  create_table "day_twitter_infos", :force => true do |t|
    t.integer  "twitter_info_id"
    t.string   "unique_id"
    t.datetime "imported_date"
    t.integer  "followers_count"
    t.integer  "friends_count"
    t.integer  "listed_count"
    t.integer  "favourites_count"
    t.integer  "statuses_count"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.date     "report_date"
  end

  add_index "day_twitter_infos", ["imported_date"], :name => "index_day_twitter_infos_on_imported_date"
  add_index "day_twitter_infos", ["twitter_info_id"], :name => "index_day_twitter_infos_on_twitter_info_id"
  add_index "day_twitter_infos", ["unique_id"], :name => "index_day_twitter_infos_on_unique_id"

  create_table "day_videos", :force => true do |t|
    t.integer  "video_id"
    t.datetime "imported_date"
    t.string   "unique_id"
    t.integer  "day_view_count"
    t.integer  "view_count"
    t.integer  "favorite_count"
    t.integer  "comment_count"
    t.string   "state"
    t.integer  "rating_min"
    t.integer  "rating_max"
    t.decimal  "rating_average",         :precision => 8, :scale => 7
    t.integer  "rater_count"
    t.integer  "likes"
    t.integer  "dislikes"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.date     "report_date"
    t.integer  "day_comments"
    t.integer  "day_favorites_added"
    t.integer  "day_favorites_removed"
    t.integer  "day_likes"
    t.integer  "day_dislikes"
    t.integer  "day_shares"
    t.integer  "day_subscribers_gained"
    t.integer  "day_subscribers_lost"
    t.integer  "week_views"
    t.integer  "report_date_wday"
  end

  add_index "day_videos", ["day_view_count"], :name => "index_day_videos_on_day_view_count"
  add_index "day_videos", ["imported_date"], :name => "index_day_videos_on_imported_date"
  add_index "day_videos", ["rating_average"], :name => "index_day_videos_on_rating_average"
  add_index "day_videos", ["unique_id"], :name => "index_day_videos_on_unique_id"
  add_index "day_videos", ["video_id"], :name => "index_day_videos_on_video_id"
  add_index "day_videos", ["view_count"], :name => "index_day_videos_on_view_count"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "facebook_infos", :force => true do |t|
    t.string   "unique_id"
    t.string   "username"
    t.string   "name"
    t.string   "category"
    t.string   "cover_id"
    t.string   "website"
    t.string   "link"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "channel_id"
  end

  add_index "facebook_infos", ["unique_id"], :name => "index_facebook_infos_on_unique_id"
  add_index "facebook_infos", ["username"], :name => "index_facebook_infos_on_username"

  create_table "goals", :force => true do |t|
    t.integer  "time_left_days"
    t.date     "time_target"
    t.integer  "views"
    t.integer  "subscribers"
    t.integer  "facebook_likes"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "view_time"
    t.integer  "channel_id"
  end

  create_table "playlist_videos", :force => true do |t|
    t.string   "playlist_unique_id"
    t.string   "video_unique_id"
    t.integer  "comment_count"
    t.integer  "dislikes"
    t.integer  "likes"
    t.integer  "favorite_count"
    t.integer  "rater_count"
    t.integer  "rating_average"
    t.integer  "view_count"
    t.integer  "day_view_count"
    t.datetime "imported_date"
    t.string   "author_name"
    t.string   "author_uri"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.datetime "published_at"
    t.datetime "uploaded_at"
    t.date     "report_date"
  end

  add_index "playlist_videos", ["day_view_count"], :name => "index_playlist_videos_on_day_view_count"
  add_index "playlist_videos", ["imported_date"], :name => "index_playlist_videos_on_imported_date"
  add_index "playlist_videos", ["playlist_unique_id"], :name => "index_playlist_videos_on_playlist_unique_id"
  add_index "playlist_videos", ["rating_average"], :name => "index_playlist_videos_on_rating_average"
  add_index "playlist_videos", ["video_unique_id"], :name => "index_playlist_videos_on_video_unique_id"
  add_index "playlist_videos", ["view_count"], :name => "index_playlist_videos_on_view_count"

  create_table "playlists", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "summary"
    t.string   "unique_id"
    t.text     "xml"
    t.datetime "published_at"
    t.string   "response_code"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.datetime "age_from"
    t.integer  "channel_id"
  end

  add_index "playlists", ["title"], :name => "index_playlists_on_title"
  add_index "playlists", ["unique_id"], :name => "index_playlists_on_unique_id"

  create_table "statuses", :force => true do |t|
    t.decimal  "lifetime_views",          :precision => 10, :scale => 0
    t.decimal  "avg_views",               :precision => 10, :scale => 4
    t.decimal  "minutes_watched",         :precision => 10, :scale => 0
    t.decimal  "avg_view_duration",       :precision => 10, :scale => 4
    t.decimal  "subscribers",             :precision => 10, :scale => 0
    t.decimal  "vscr",                    :precision => 10, :scale => 4
    t.integer  "fb_likes"
    t.integer  "twitter_followers"
    t.integer  "plus_followers"
    t.integer  "tumblr_followers"
    t.integer  "instagram_followers"
    t.string   "user_id"
    t.datetime "imported_date"
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.integer  "channel_id"
    t.date     "report_date"
    t.decimal  "day_avg_views",           :precision => 10, :scale => 4
    t.decimal  "day_avg_view_duration",   :precision => 10, :scale => 4
    t.decimal  "day_vscr",                :precision => 10, :scale => 4
    t.decimal  "day_views",               :precision => 10, :scale => 0
    t.decimal  "day_minutes_watched",     :precision => 10, :scale => 0
    t.decimal  "day_subscribers",         :precision => 10, :scale => 0
    t.integer  "day_fb_likes"
    t.integer  "day_twitter_followers"
    t.integer  "day_plus_followers"
    t.integer  "day_tumblr_followers"
    t.integer  "day_instagram_followers"
  end

  create_table "trackers", :force => true do |t|
    t.string   "type"
    t.string   "unique_id"
    t.integer  "this_week_rank"
    t.integer  "last_week_rank"
    t.string   "name"
    t.integer  "weeks_on_chart"
    t.integer  "total_aggregate_views"
    t.integer  "this_week_views"
    t.string   "weekly_percent_views"
    t.decimal  "time_since_upload",     :precision => 10, :scale => 0
    t.integer  "comments"
    t.integer  "shares"
    t.integer  "videos_in_series"
    t.datetime "tracked_date"
    t.datetime "uploaded_at"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "trackable_type"
    t.integer  "trackable_id"
    t.integer  "video_id"
    t.integer  "playlist_id"
    t.date     "report_date"
    t.integer  "peak_position"
    t.decimal  "percent_change_views",  :precision => 10, :scale => 4
    t.integer  "report_date_wday"
    t.string   "channel_name"
  end

  create_table "twitter_infos", :force => true do |t|
    t.string   "unique_id"
    t.string   "screen_name"
    t.string   "name"
    t.string   "location"
    t.string   "url"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "channel_id"
  end

  add_index "twitter_infos", ["screen_name"], :name => "index_twitter_infos_on_screen_name"
  add_index "twitter_infos", ["unique_id"], :name => "index_twitter_infos_on_unique_id"

  create_table "videos", :force => true do |t|
    t.string   "unique_id"
    t.text     "categories"
    t.text     "keywords"
    t.text     "description"
    t.string   "title"
    t.text     "thumbnails"
    t.string   "player_url"
    t.datetime "published_at"
    t.datetime "uploaded_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "channel_id"
  end

  add_index "videos", ["title"], :name => "index_videos_on_title"
  add_index "videos", ["unique_id"], :name => "index_videos_on_unique_id"

end
