class Sync

	class << self
		attr :client, :analytics, :youtube, :playlists, :listItems, :videos

		def authorize!(channel)
			begin
		    @client ||= Google::APIClient.new
		    config = YOUTUBE_ANALYTICS[channel.username_display.to_sym]
	      Rails.logger.info(config.inspect)

		    @client.authorization.client_id = config[:client_id]
		    @client.authorization.client_secret = config[:client_secret]
		    @client.authorization.scope = OAUTH_SCOPE
		    @client.authorization.redirect_uri = config[:redirect_uri]
		    @client.authorization.code = config[:authorization_code]
		    @client.authorization.refresh_token = config[:authorization_refresh_token]
		      Rails.logger.info(@client.inspect)

		    begin
		      @client.authorization.fetch_access_token!
		    rescue
		      data = {
		        :client_id => config[:client_id],
		        :client_secret => config[:client_secret],
		        :refresh_token => @client.authorization.refresh_token,
		        :grant_type => "refresh_token"
		      }
		      response = JSON.parse(RestClient.post "https://accounts.google.com/o/oauth2/token", data)
		      @client.authorization.access_token = response["access_token"]
		    end
		    return true
		  rescue Exception => ex
		  	Rails.logger.error("!!! AUTHORIZE exception: #{ex.message} --#{ex.inspect}")
		  	return false
		  end

		end
		# END authorize!

		def sync_videos(channel)
			yvideos = videos(channel)
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

		def sync_detail_video(video)
			channel = video.channel
			return false if channel.blank?
			return false unless authorize!(channel)
	    @analytics  = @client.discovered_api('youtubeAnalytics','v1')
	    startDate  = '2006-01-01'
	    endDate    = Time.now.strftime("%Y-%m-%d")
	    channelId  = YOUTUBE[channel.username.to_sym][:channel_id]
	    visitCount = client.execute(:api_method => analytics.reports.query, 
	    	:parameters => {
	      	'start-date' => startDate,
	      	'end-date' => endDate,
	      	ids: 'channel==' + channelId,
	      	dimensions: 'day',
	      	metrics: 'views,comments,favoritesAdded,likes,dislikes,shares,subscribersGained'
	    })

	    puts visitCount.data.inspect
	    visitCount.data.rows.sort_by{|d,v| Date.parse(d)}.each do |r|
				puts r.inspect
		  end
		end
		# END-DEF sync_detail_video

		def sync(channel)
			sync_videos(channel)
		end


		private
		def videos(channel)
      total_pages = 1
      page = 1
      videos = []
      begin
      	begin
        	results = YoutubeClient.youtube_client.videos_by(:user => channel.unique_id, :page => page)
        	videos += (results.videos rescue [])
        	total_pages = results.total_pages if total_pages == 1
	      	page += 1
	      	rescue "Exception"
  	    end while page <= results.total_pages
    	rescue Exception => ex
    		Rails.logger.error("Import videos error: #{ex.message}")
    	end
			videos      
		end


	end
end