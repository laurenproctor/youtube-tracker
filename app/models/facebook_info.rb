class FacebookInfo < ActiveRecord::Base
  attr_accessible :category, :cover_id, :description, :link, :name,
                  :unique_id, :username, :website, :channel_id

  belongs_to :channel
  has_many :day_facebook_infos

  class << self
    def search_import(username = 'officialcomedy')
        json = JSON.parse(open(FACEBOOK[:api_url] + FACEBOOK[username.to_sym][:user_id]).read)
        import json[FACEBOOK[username.to_sym][:user_id]], username
    end
  end

  private

    def self.import(user, username)
      today = Date.today.to_datetime
      channel = Channel.find_by_username username
      params = {
          :unique_id => "#{user['username']}_#{user['id']}", :cover_id => user['cover']['cover_id'],
          :category => user['category'], :description => user['description'],
          :link => user['link'], :name => user['name'],
          :username => user['username'], :website => user['website'], :channel_id => channel.id
      }
      param2s = {
          :unique_id => params[:unique_id], :imported_date => today,
          :likes => user['likes'], :talking_about_count => user['talking_about_count']
      }
      unless facebook_info = FacebookInfo.find_by_unique_id(params[:unique_id])
        p = FacebookInfo.create( params)
        param2s.merge!(:facebook_info_id => p.id)
      else
        facebook_info.update_attributes(params)
        param2s.merge!(:facebook_info_id => facebook_info.id)
      end

      unless day_facebook_info = DayFacebookInfo.find_by_unique_id_and_imported_date(params[:unique_id], today)
        DayFacebookInfo.create param2s
      else
        day_facebook_info.update_attributes param2s
      end
  end
end

