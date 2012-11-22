class Status < ActiveRecord::Base
  attr_accessible :avg_view_duration, :avg_views, :fb_likes, :instagram_followers, :lifetime_views,
                  :minutes_watched, :plus_followers, :subscribers, :tumblr_followers, :twitter_followers,
                  :vscr, :user_id , :imported_date, :channel_id

  belongs_to :channel

  class << self

    def search_import channel
        client = YoutubeClient.youtube_client(channel.username)
        begin
          find = client.videos_by(:user => channel.username, :page => page)
          import find.videos
          page += 1
          total_pages = find.total_pages if total_pages == 1
        end while page <= find.total_pages
        puts "Import for #{channel} ..................finished"
        logger.info "import successfully #{ page -1 } / #{ total_pages}"
      end
  end
end

