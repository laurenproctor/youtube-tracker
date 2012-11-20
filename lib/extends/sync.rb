class Sync

	class << self
		attr :client, :youtube, :playlists, :listItems, :videos

		def authorize!(channel)
			begin
		    @client ||= Google::APIClient.new
		    config = YOUTUBE_ANALYTICS[channel]
		    @client.authorization.client_id = config[:client_id]
		    @client.authorization.client_secret = config[:client_secret]
		    @client.authorization.scope = OAUTH_SCOPE
		    @client.authorization.redirect_uri = config[:redirect_uri]
		    @client.authorization.code = config[:authorization_code]
		    @client.authorization.refresh_token = config[:authorization_refresh_token]

		    begin
		      @client.authorization.fetch_access_token!
		    rescue
		      data = {
		        :client_id => config[:client_id],
		        :client_secret => config[:client_secret],
		        :refresh_token => client.authorization.refresh_token,
		        :grant_type => "refresh_token"
		      }
		      response = JSON.parse(RestClient.post "https://accounts.google.com/o/oauth2/token", data)
		      @client.authorization.access_token = response["access_token"]
		    end
				@youtube = @client.discovered_api('youtube','v3')
		    return true
		  rescue Exception => ex
		  	Rails.logger.error("!!! AUTHORIZE exception: #{ex.message}")
		  	return false
		  end

		end
		# END authorize!

		def videos(channel)
      total_pages = 1
      page = 1
      videos = []
      begin
        results = YoutubeClient.youtube_client.videos_by(:user => channel.unique_id, :page => page)
        videos += results.videos
        page += 1
        total_pages = results.total_pages if total_pages == 1
      end while page <= results.total_pages
      logger.info "import successfully #{ page -1 } / #{ total_pages}"
		end

	end
end