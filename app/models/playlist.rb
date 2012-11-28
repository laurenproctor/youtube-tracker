class Playlist < ActiveRecord::Base
  attr_accessible :description, :unique_id, :published_at,
                  :response_code, :summary, :title, :xml,
                  :age_from, :channel_id

  belongs_to :channel
  has_many :day_playlists

  class << self
    def search_import(channel)
        client = YoutubeClient.youtube_client(channel.username)
        playlists = client.all_playlists(channel.username)
        total = 1
        playlists.each_with_index do |p, index|
          playlist = client.playlist(p.playlist_id)
          import(playlist, channel)
          total = index
        end
        puts "Import for #{channel} ..................finished"
        logger.info "import successfully #{total + 1} / #{ playlists.size } playlists"
    end
  end

  def last_info
    DayPlaylist.find_by_unique_id_and_imported_date(self.unique_id, TimeUtil.today)
  end

  def avg_views
    DayPlaylist.where(:unique_id=> self.unique_id,:imported_date => TimeUtil.today).
      select('avg(day_view_count) as day_view_count').
      select('avg(view_count) as view_count').first
  end

  private

    def self.import(yt_playlist, channel)
       today = TimeUtil.today
        params = { :channel_id => channel.id,
          :title => yt_playlist.title, :unique_id => yt_playlist.playlist_id,
          :description => yt_playlist.description, :published_at => yt_playlist.published,
          :summary => yt_playlist.summary, :xml => nil,
          :response_code => yt_playlist.response_code,
          :age_from => yt_playlist.videos.map(&:uploaded_at).compact.min
        }

        dv = {:day_view_count => 0, :view_count => 0, :rater_count => 0,
            :comment_count => 0, :favorite_count => 0, :rating_average => 0,
            :dislikes => 0, :likes => 0
        }
        yt_playlist.videos.each do |vd|
           dv[:view_count]      += vd.view_count || 0
           dv[:comment_count]   += vd.comment_count || 0
           dv[:favorite_count]  += vd.favorite_count || 0
           dv[:dislikes]        += vd.rating.try(:dislikes) || 0
           dv[:likes]           += vd.rating.try(:likes) || 0
           dv[:rater_count]     += vd.rating.try(:rater_count) || 0
           dv[:rating_average]  += vd.rating.try(:average) || 0
        end
        param2s = { :unique_id => yt_playlist.playlist_id, :imported_date => today,
            :report_date => today - 1.day,
            :day_view_count => dv[:day_view_count], :view_count => dv[:view_count],
            :comment_count => dv[:comment_count], :favorite_count => dv[:favorite_count],
            :dislikes => dv[:dislikes], :likes => dv[:likes], :rater_count => dv[:rater_count],
            :rating_average => dv[:rating_average], :video_count => yt_playlist.videos.size,
            :video_unique_ids => yt_playlist.videos.map(&:unique_id)
        }

        unless playlist = channel.playlists.find_by_unique_id(yt_playlist.playlist_id)
          p = Playlist.create( params)
          param2s.merge!(:playlist_id => p.id)
        else
          params[:age_from] = playlist.age_from if playlist.age_from
          playlist.update_attributes(params)
          param2s.merge!(:playlist_id => playlist.id)
        end
        yesterday_playlist = channel.day_playlists.find_by_unique_id_and_imported_date(
          yt_playlist.playlist_id, today - 1.day)
        if yesterday_playlist
          param2s.merge!(:day_view_count => param2s[:view_count] - yesterday_playlist.view_count)
        end
        unless day_playlist = channel.day_playlists.find_by_unique_id_and_imported_date(yt_playlist.playlist_id, today)
          day_playlist = DayPlaylist.create param2s
        else
          day_playlist.update_attributes param2s
        end
    end

=begin
    def self.import_video(youtube_video, today, playlist_unique_id)
      param2s = {
          :playlist_unique_id => playlist_unique_id,
          :comment_count  => youtube_video.comment_count || 0, :imported_date => today,
          :day_view_count => 0, :view_count => youtube_video.view_count || 0,
          :favorite_count => youtube_video.favorite_count || 0, :video_unique_id => youtube_video.unique_id,
          :dislikes => youtube_video.rating.try(:dislikes) || 0, :likes => youtube_video.rating.try(:likes) || 0,
          :rater_count => youtube_video.rating.try(:rater_count) || 0,
          :rating_average => youtube_video.rating.try(:average) || 0,
          :author_name    => youtube_video.author.try(:name),
          :author_uri     => youtube_video.author.try(:uri),
          :published_at   => youtube_video.published_at,
          :uploaded_at    => youtube_video.uploaded_at
      }
      yesterday_video = PlaylistVideo.find_by_video_unique_id_and_playlist_unique_id_and_imported_date(
          youtube_video.unique_id, playlist_unique_id, today - 1.day)
      param2s.merge!(:day_view_count => youtube_video.view_count - yesterday_video.view_count) if yesterday_video
      unless playlist_video = PlaylistVideo.find_by_video_unique_id_and_playlist_unique_id_and_imported_date(
          youtube_video.unique_id, playlist_unique_id, today)
        PlaylistVideo.create param2s
      else
        playlist_video.update_attributes param2s
      end
    end
=end
end

