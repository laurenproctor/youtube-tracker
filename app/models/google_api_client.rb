class GoogleApiClient
  def self.youtube_analytics_client channel
    config = YOUTUBE_ANALYTICS[channel.to_sym]
    client = Google::APIClient.new

    # Request authorization
    client.authorization.client_id = config[:client_id]
    client.authorization.client_secret = config[:client_secret]
    client.authorization.scope = OAUTH_SCOPE
    client.authorization.redirect_uri = config[:redirect_uri]

    #uri = client.authorization.authorization_uri
    client.authorization.code = config[:authorization_code]
    client.authorization.refresh_token = config[:authorization_refresh_token]

    begin
      client.authorization.fetch_access_token!
    rescue
      data = {
        :client_id => config[:client_id],
        :client_secret => config[:client_secret],
        :refresh_token => client.authorization.refresh_token,
        :grant_type => "refresh_token"
      }
      response = JSON.parse(RestClient.post "https://accounts.google.com/o/oauth2/token", data)
      client.authorization.access_token = response["access_token"]
    end

    client
  end
end

