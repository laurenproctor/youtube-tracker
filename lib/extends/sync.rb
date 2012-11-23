class Sync

	class << self
=begin
		# attr :client, :analytics, :youtube, :playlists, :listItems, :videos

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
=end

		def sync_videos(channel)
			yvideos = videos(channel)
      today = Date.today.to_datetime
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

		def sync_detail_video(client, analytics, video, end_date=Date.today)
      start_date = video.published_at
			channel = video.channel
			return false if channel.blank?

	    channelId  = YOUTUBE[channel.username.to_sym][:channel_id]
	    visitCount = client.execute(:api_method => analytics.reports.query,
	    	:parameters => {
	      	'start-date' => start_date.strftime("%Y-%m-%d"),
	      	'end-date' => end_date.strftime("%Y-%m-%d"),
	      	ids: 'channel==' + channelId,
	      	dimensions: 'day',
	      	metrics: 'views,comments,favoritesAdded,likes,dislikes,shares',
	      	filters: "video==" + video.unique_id
	    })
      total_view_count = 0;
	    # puts visitCount.data.inspect
	    visitCount.data.rows.sort_by{|d,v| Date.parse(d)}.each do |r|
				puts r.inspect
        next_date = r[0].to_datetime + 1.day

        day_video = video.day_videos.find_or_create_by_imported_date(next_date)
        attrs = {
            :unique_id => video.unique_id, :imported_date => next_date,
            :report_date    => r[0].to_date,
            :day_view_count => r[1], :view_count => total_view_count += r[1],
            :comment_count  => r[2],
            :favorite_count => r[3],
            :likes    => r[4],
            :dislikes => r[5]
        }
        unless day_video.update_attributes(attrs)
					Rails.logger.info("Could not sync detail for video##{v.unique_id} on #{r[0]}")
				end
		  end

		end
		# END-DEF sync_detail_video

		private
		  def videos(channel)
        client = YoutubeClient.youtube_client(channel.username)
        total_pages = 1
        page = 1
        videos = []
        begin
          results = client.videos_by(:user => channel.unique_id, :page => page)
          videos += (results.videos rescue [])
          page += 1
          total_pages = results.total_pages if total_pages == 1
        end while page <= results.total_pages
        puts "import successfully #{ page -1 } / #{ total_pages}"
			  videos
		  end


	end
end

