class TwitterInfo < ActiveRecord::Base
  attr_accessible :description, :location, :name, :screen_name, :unique_id, :url, :channel_id

  belongs_to :channel
  has_many :day_twitter_infos

  class << self
    def search_import(channel)
        json = JSON.parse(open(TWITTER[:api_url] + TWITTER[channel.username.to_sym][:user_id]).read)
        import json, channel
    end
  end

  private

    def self.import(info, channel)
      today = TimeUtil.today
      params = {
          :unique_id => "#{info['screen_name']}_#{info['id']}", :location => info['location'],
          :screen_name => info['screen_name'], :description => info['description'],
          :url => info['url'], :name => info['name'], :channel_id => channel.id
      }
      param2s = {
          :unique_id => params[:unique_id], :imported_date => today,
          :report_date => today - 1.day,
          :favourites_count => info['favourites_count'], :followers_count => info['followers_count'],
          :friends_count => info['friends_count'], :listed_count => info['listed_count'],
          :statuses_count => info['statuses_count'],
      }
      unless twitter_info = channel.twitter_infos.find_by_unique_id(params[:unique_id])
        p = TwitterInfo.create( params)
        param2s.merge!(:twitter_info_id => p.id)
      else
        twitter_info.update_attributes(params)
        param2s.merge!(:twitter_info_id => twitter_info.id)
      end

      unless day_twitter_info = channel.day_twitter_infos.
        find_by_unique_id_and_imported_date(params[:unique_id], today)
        DayTwitterInfo.create param2s
      else
        day_twitter_info.update_attributes param2s
      end
    end
end

