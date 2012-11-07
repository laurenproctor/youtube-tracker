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

ActiveRecord::Schema.define(:version => 20121107172428) do

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
    t.decimal  "rating_average", :precision => 8, :scale => 7
    t.integer  "rater_count"
    t.integer  "likes"
    t.integer  "dislikes"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  add_index "day_videos", ["day_view_count"], :name => "index_day_videos_on_day_view_count"
  add_index "day_videos", ["imported_date"], :name => "index_day_videos_on_imported_date"
  add_index "day_videos", ["rating_average"], :name => "index_day_videos_on_rating_average"
  add_index "day_videos", ["unique_id"], :name => "index_day_videos_on_unique_id"
  add_index "day_videos", ["video_id"], :name => "index_day_videos_on_video_id"
  add_index "day_videos", ["view_count"], :name => "index_day_videos_on_view_count"

  create_table "playlists", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "summary"
    t.string   "playlist_id"
    t.text     "xml"
    t.datetime "published_at"
    t.string   "response_code"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "playlists", ["playlist_id"], :name => "index_playlists_on_playlist_id"
  add_index "playlists", ["title"], :name => "index_playlists_on_title"

  create_table "trackers", :force => true do |t|
    t.string   "type"
    t.string   "unique_id"
    t.string   "this_week_rank"
    t.string   "last_week_rank"
    t.string   "name"
    t.string   "weeks_on_chart"
    t.integer  "total_aggregate_views"
    t.integer  "this_week_views"
    t.string   "plus_minus_views"
    t.string   "time_since_upload"
    t.integer  "comments"
    t.integer  "shares"
    t.integer  "videos_in_series"
    t.datetime "tracked_date"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

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
  end

  add_index "videos", ["title"], :name => "index_videos_on_title"
  add_index "videos", ["unique_id"], :name => "index_videos_on_unique_id"

end
