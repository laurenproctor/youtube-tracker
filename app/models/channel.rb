class Channel < ActiveRecord::Base
  attr_accessible :avatar, :location, :unique_id, :username, 
                  :username_display, :join_date
  has_many :day_channels
  has_many :videos

  class << self
    def search_import (user_id = YOUTUBE[:officialcomedy][:user_id])
        import YoutubeClient.youtube_client.profile(user_id)
    end
  end

  private
    def self.import(channel)
      today = Time.now.beginning_of_day
      params = { :unique_id => channel.user_id, :username => channel.username,
          :username_display => channel.username_display, :join_date => channel.join_date,
          :location => channel.location, :avatar => channel.avatar
      }
      param2s = { :unique_id => channel.user_id, :imported_date => today,
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

