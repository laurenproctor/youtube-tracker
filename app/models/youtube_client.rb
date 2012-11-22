class YoutubeClient
  def self.youtube_client(channel)
    config = YOUTUBE_ANALYTICS[channel.to_sym]
    client = YouTubeIt::OAuth2Client.new(client_access_token: "",
      client_refresh_token: config[:authorization_refresh_token],
      client_id: config[:client_id],
      client_secret: config[:client_secret],
      dev_key: YOUTUBE[:dev_key], expires_at: "")
    client.refresh_access_token!
    client
  end
end

