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
				# @youtube = @client.discovered_api('youtube','v3')
		    @analytics  = client.discovered_api('youtubeAnalytics','v1')
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
      	begin
        	results = YoutubeClient.youtube_client.videos_by(:user => channel.unique_id, :page => page)
        	videos += (results.videos rescue [])
        	total_pages = results.total_pages if total_pages == 1
      	rescue Exception => ex
      		Rails.logger.error("Import videos error: #{ex.message}")
      	end
      	page += 1
      end while page <= results.total_pages
			videos      
		end

		def import_videos(yvideos, channel)
      today = Time.now.beginning_of_day
			yvideos.each do |v|
				video = channel.videos.find_or_create_by_unique_id(v.unique_id)
        attrs = { 	:title => v.title, 
        						:unique_id => v.unique_id,
            				:categories => v.categories.try(:to_json), :description => v.description,
				            :keywords => v.keywords.try(:to_json), 
				            :player_url => v.player_url,
				            :published_at => v.published_at,
				            :uploaded_at => v.uploaded_at,
				            :thumbnails => v.thumbnails.try(:to_json) 
				          }
				unless video.update_attributes(attrs)
					Rails.logger.info("Could not sync video##{v.unique_id}")
				end
			end
		end

		def sync(channel)
			videos(channel)
		end

	end
end