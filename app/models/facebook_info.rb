class FacebookInfo < ActiveRecord::Base
  attr_accessible :category, :cover_id, :description, :link, :name,
                  :unique_id, :username, :website, :channel_id, :report_date

  belongs_to :channel
  has_many :day_facebook_infos

  class << self
    def search_import(channel)
        json = JSON.parse(open(FACEBOOK[:api_url] + FACEBOOK[channel.username.to_sym][:user_id]).read)
        import json[FACEBOOK[channel.username.to_sym][:user_id]], channel
    end
  end

  private

    def self.import(info, channel)
      today = TimeUtil.today
      params = {
          :unique_id => "#{info['username']}_#{info['id']}", :cover_id => "#{info['cover']['cover_id']}",
          :category => info['category'], :description => info['description'],
          :link => info['link'], :name => info['name'],
          :username => info['username'], :website => info['website'], :channel_id => channel.id
      }
      param2s = {
          :unique_id => params[:unique_id], :imported_date => today,
          :report_date => today - 1.day,
          :likes => info['likes'], :talking_about_count => info['talking_about_count']
      }
      unless facebook_info = channel.facebook_infos.find_by_unique_id(params[:unique_id])
        p = FacebookInfo.create( params)
        param2s.merge!(:facebook_info_id => p.id)
      else
        facebook_info.update_attributes(params)
        param2s.merge!(:facebook_info_id => facebook_info.id)
      end

      unless day_facebook_info = channel.day_facebook_infos.
        find_by_unique_id_and_imported_date(params[:unique_id], today)
        DayFacebookInfo.create param2s
      else
        day_facebook_info.update_attributes param2s
      end
  end
end

