class Video < ActiveRecord::Base
  attr_accessible :categories, :description, :keywords, :player_url, :published_at
  attr_accessible:thumbnails, :title, :unique_id, :uploaded_at

  has_many :day_videos

  class << self

    def search_import
        total_pages = 1
        page = 1
        begin
          find = YoutubeClient.youtube_client.videos_by(:user => YOUTUBE[:user_id], :page => page)
          import find.videos
          page += 1
          total_pages = find.total_pages if total_pages == 1
        end while page <= find.total_pages
        logger.info "import successfully #{ page -1 } / #{ total_pages}"
      end
  end

  def last_info
    DayVideo.find_by_unique_id_and_imported_date(self.unique_id, Time.now.beginning_of_day)
  end

  private
    def self.import(youtube_videos)
      today = Time.now.beginning_of_day
      youtube_videos.each_with_index do |p, index|
        params = { :title => p.title, :unique_id => p.unique_id,
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
        unless video = Video.find_by_unique_id(p.unique_id)
          v = Video.create( params)
          param2s.merge!(:video_id => v.id)
        else
          video.update_attributes(params)
          param2s.merge!(:video_id => video.id)
        end
        yesterday_video = DayVideo.find_by_unique_id_and_imported_date(p.unique_id, today - 1.day)
        param2s.merge!(:day_view_count => p.view_count - yesterday_video.view_count) if yesterday_video
        unless day_video = DayVideo.find_by_unique_id_and_imported_date(p.unique_id, today)
          DayVideo.create param2s
        else
          day_video.update_attributes param2s
        end
      end
    end
end

