class YoutubeClient
  def self.youtube_client
    @yt_client ||= YouTubeIt::Client.new(:dev_key => YOUTUBE[:dev_key])
  end
end

