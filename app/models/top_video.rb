class TopVideo < Tracker
  class << self
      def track
        videos = TopVideo.youtube_client.videos_by(:top_rated,:user => YOUTUBE[:user_id]).videos
        videos.each_with_index do |p, index|
          unless video = TopVideo.find_by_unique_id(p.unique_id)
            TopVideo.create( :unique_id => p.unique_id, :name => p.title, :this_week_rank => index + 1,
              :total_aggregate_views => p.view_count)
          else
            video.update_attributes( :unique_id => p.unique_id, :name => p.title, :this_week_rank => index + 1,
              :total_aggregate_views => p.view_count)
          end
        end
      end

  end
end

