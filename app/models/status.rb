class Status < ActiveRecord::Base
  attr_accessible :avg_view_duration, :avg_views, :fb_likes, :instagram_followers, :lifetime_views,
                  :minutes_watched, :plus_followers, :subscribers, :tumblr_followers, :twitter_followers,
                  :vscr, :user_id , :imported_date
  class << self

    def search_import
        begin
          find = YoutubeClient.youtube_client.videos_by(:user => YOUTUBE[:user_id], :page => page)
          import find.videos
          page += 1
          total_pages = find.total_pages if total_pages == 1
        end while page <= find.total_pages
        logger.info "import successfully #{ page -1 } / #{ total_pages}"
      end
  end
end

