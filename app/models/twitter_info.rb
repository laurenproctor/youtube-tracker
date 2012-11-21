class TwitterInfo < ActiveRecord::Base
  attr_accessible :description, :location, :name, :screen_name, :unique_id, :url
  has_many :day_twitter_infos

  class << self
    def search_import
        json = JSON.parse(open(TWITTER[:api_url] + TWITTER[:user_id]).read)
        import json
    end
  end

  private

    def self.import(user)
      today = Date.today.to_datetime
      params = {
          :unique_id => "#{user['screen_name']}_#{user['id']}", :location => user['location'],
          :screen_name => user['screen_name'], :description => user['description'],
          :url => user['url'], :name => user['name']
      }
      param2s = {
          :unique_id => params[:unique_id], :imported_date => today,
          :favourites_count => user['favourites_count'], :followers_count => user['followers_count'],
          :friends_count => user['friends_count'], :listed_count => user['listed_count'],
          :statuses_count => user['statuses_count'],
      }
      unless twitter_info = TwitterInfo.find_by_unique_id(params[:unique_id])
        p = TwitterInfo.create( params)
        param2s.merge!(:twitter_info_id => p.id)
      else
        twitter_info.update_attributes(params)
        param2s.merge!(:twitter_info_id => twitter_info.id)
      end

      unless day_twitter_info = DayTwitterInfo.find_by_unique_id_and_imported_date(params[:unique_id], today)
        DayTwitterInfo.create param2s
      else
        day_twitter_info.update_attributes param2s
      end
    end
end

