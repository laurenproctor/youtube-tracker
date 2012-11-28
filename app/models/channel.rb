class Channel < ActiveRecord::Base
  attr_accessible :avatar, :location, :unique_id, :username,
                  :username_display, :join_date
  has_many :day_channels
  has_many :videos
  has_many :playlists
  has_many :day_playlists, :through => :playlists
  has_many :day_playlist_trackers, :through => :day_playlists, :source => :tracker
  has_many :day_videos, :through => :videos
  has_many :day_video_trackers, :through => :day_videos, :source => :tracker
  has_many :facebook_infos
  has_many :twitter_infos
  has_many :day_facebook_infos, :through => :facebook_infos
  has_many :day_twitter_infos,  :through => :twitter_infos
  has_many :statuses
  has_one  :goal

  class << self
    def search_import(channel)
      user_id = YOUTUBE[channel.to_sym][:user_id]
      import YoutubeClient.youtube_client(channel).profile(user_id)
    end
  end

  private
    def self.import(channel)
      today = TimeUtil.today
      params = { :unique_id => channel.user_id, :username => channel.username,
          :username_display => channel.username_display, :join_date => channel.join_date,
          :location => channel.location, :avatar => channel.avatar
      }
      param2s = { :unique_id => channel.user_id, :imported_date => today,
          :report_date => today - 1.day,
          :subscribers => channel.subscribers, :view_count => channel.view_count,
          :upload_count => channel.upload_count, :upload_views => channel.upload_views
      }
      unless chan = Channel.find_by_unique_id(channel.user_id)
        v = Channel.create( params)
        param2s.merge!(:channel_id => v.id)
      else
        chan.update_attributes(params)
        param2s.merge!(:channel_id => chan.id)
      end

      unless day_channel = DayChannel.find_by_unique_id_and_imported_date(channel.user_id, today)
        DayChannel.create param2s
      else
        day_channel.update_attributes param2s
      end
    end
end

