class Video < ActiveRecord::Base
  attr_accessible :categories, :description, :keywords,
                  :player_url, :published_at,
                  :thumbnails, :title, :unique_id,
                  :uploaded_at, :channel_id

  belongs_to :channel
  has_many :day_videos
=begin
  class << self

    def search_import channel
        client = YoutubeClient.youtube_client(channel.username)
        total_pages = 1
        page = 1
        begin
          find = client.videos_by(:user => channel.username, :page => page)
          import find.videos, channel
          page += 1
          total_pages = find.total_pages if total_pages == 1
        end while page <= find.total_pages
        logger.info "import successfully #{ page -1 } / #{ total_pages}"
      end
  end

  def last_info
    DayVideo.find_by_unique_id_and_imported_date(self.unique_id, TimeUtil.today)
  end

  def avg_views_per_day imported_date_range
    DayVideo.where(:unique_id=> self.unique_id,:imported_date => imported_date_range).
      select('avg(day_view_count) as day_view_count')
  end

  private
    def self.import(youtube_videos, channel)
      today = TimeUtil.today
      youtube_videos.each_with_index do |p, index|
        params = { :title => p.title, :unique_id => p.unique_id, :channel_id => channel.id,
            :categories => p.categories.try(:to_json), :description => p.description,
            :keywords => p.keywords.try(:to_json), :player_url => p.player_url,
            :published_at => p.published_at,:uploaded_at => p.uploaded_at,
            :thumbnails => p.thumbnails.try(:to_json) }
        param2s = { :comment_count => p.comment_count || 0, :imported_date => today,
            :day_view_count => 0, :view_count => p.view_count || 0,
            :favorite_count => p.favorite_count || 0, :unique_id => p.unique_id,
            :state => p.state, :dislikes => p.rating.try(:dislikes) || 0, :likes => p.rating.try(:likes) || 0,
            :rater_count => p.rating.try(:rater_count) || 0,
            :rating_average => p.rating.try(:average) || 0,
            :rating_max => p.rating.try(:max) || 0, :rating_min => p.rating.try(:min) || 0
        }
        unless video = channel.videos.find_by_unique_id(p.unique_id)
          v = Video.create( params)
          param2s.merge!(:video_id => v.id)
        else
          video.update_attributes(params)
          param2s.merge!(:video_id => video.id)
        end
        yesterday_video = channel.day_videos.find_by_unique_id_and_imported_date(p.unique_id, today - 1.day)
        param2s.merge!(:day_view_count => p.view_count - yesterday_video.view_count) if yesterday_video
        unless day_video = channel.day_videos.find_by_unique_id_and_imported_date(p.unique_id, today)
          DayVideo.create param2s
        else
          day_video.update_attributes param2s
        end
      end
    end
=end
end

