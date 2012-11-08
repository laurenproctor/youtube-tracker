class Playlist < ActiveRecord::Base
  attr_accessible :description, :unique_id, :published_at, :response_code, :summary, :title, :xml
  has_many :playlists

  class << self
    def search_import
        playlists = YoutubeClient.youtube_client.all_playlists(YOUTUBE[:user_id])
        total = 1
        playlists.each_with_index do |p, index|
          playlist = YoutubeClient.youtube_client.playlist(p.playlist_id)
          import playlist
          total = index
        end
        logger.info "import successfully #{total + 1} / #{ playlists.size } playlists"
    end
  end

  private
    def self.import(yt_playlist)
       today = Time.now.beginning_of_day
        params = { :title => yt_playlist.title, :unique_id => yt_playlist.playlist_id,
          :description => yt_playlist.description, :published_at => yt_playlist.published,
          :summary => yt_playlist.summary, :xml => yt_playlist.xml, :response_code => yt_playlist.response_code
        }
        json_list = ActiveSupport::JSON.decode (
          DayVideo.where(:unique_id => yt_playlist.videos.map(&:unique_id), :imported_date => today).
          select('sum(comment_count) as comment_count, sum(favorite_count) as favorite_count').
          select('sum(dislikes) as dislikes, sum(likes) as likes').
          select('sum(rater_count) as rater_count, sum(rating_average) as rating_average').
          select('sum(view_count) as view_count, sum(day_view_count) as day_view_count').to_json
        )
        dv = DayVideo.new json_list[0]
        param2s = { :unique_id => yt_playlist.playlist_id, :imported_date => today,
            :day_view_count => dv.day_view_count, :view_count => dv.view_count,
            :comment_count => dv.comment_count, :favorite_count => dv.favorite_count,
            :dislikes => dv.dislikes, :likes => dv.likes,
            :rater_count => dv.rater_count,
            :rating_average => dv.rating_average, :video_count => yt_playlist.videos.size
        }
        unless playlist = Playlist.find_by_unique_id(yt_playlist.playlist_id)
          p = Playlist.create( params)
          param2s.merge!(:playlist_id => p.id)
        else
          playlist.update_attributes(params)
          param2s.merge!(:playlist_id => playlist.id)
        end

        unless day_playlist = DayPlaylist.find_by_unique_id_and_imported_date(yt_playlist.playlist_id, today)
          DayPlaylist.create param2s
        else
          day_video.update_attributes param2s
        end
    end
end

