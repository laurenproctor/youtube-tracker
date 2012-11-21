require 'rubygems'
require 'json'
require 'google/api_client'
require 'date'
require 'rest_client'

# Get your credentials from the APIs Console
# API_KEY = 'AIzaSyAcH-mB5I7KyMabpODQ0SylpdpE6gmHwco'
CLIENT_ID = "336238439913-h808gc6ja3sqpmq1k336k7sqn8crahs3.apps.googleusercontent.com"
CLIENT_SECRET = "CQa4O4jm8Y4r2GGid-5OJx1A"
OAUTH_SCOPE = ["https://www.googleapis.com/auth/yt-analytics.readonly", "https://gdata.youtube.com"]
REDIRECT_URI = "urn:ietf:wg:oauth:2.0:oob"

# Create a new API client & load the Google Drive API
client = Google::APIClient.new

# Request authorization
client.authorization.client_id = CLIENT_ID
client.authorization.client_secret = CLIENT_SECRET
client.authorization.scope = OAUTH_SCOPE
client.authorization.redirect_uri = REDIRECT_URI

#uri = client.authorization.authorization_uri

client.authorization.refresh_token = "1/r-vvKR6IHMn20sbdUiweGFdRnOw4zA1sQhqt2HLzVJo"
client.authorization.code = "4/neoRfblSPJuFA29A17XE2mq8aCBg.giMb7NJsUYYWXE-sT2ZLcbRHJCAtdgI"
begin
  client.authorization.fetch_access_token!
rescue
  data = {
    :client_id => CLIENT_ID,
    :client_secret => CLIENT_SECRET,
    :refresh_token => client.authorization.refresh_token,
    :grant_type => "refresh_token"
  }
  response = JSON.parse(RestClient.post "https://accounts.google.com/o/oauth2/token", data)
  client.authorization.access_token = response["access_token"]
end

analytics = client.discovered_api('youtubeAnalytics','v1')
startDate = '2006-01-01'  # DateTime.now.prev_month.strftime("%Y-%m-%d")
endDate = '2013-01-01' # DateTime.now.strftime("%Y-%m-%d")
channelId = 'UCsert8exifX1uUnqaoY3dqA'
videoId = 'CFu4htAIoBI'
visitCount = client.execute(:api_method => analytics.reports.query, :parameters => {
  'start-date' => startDate,
  'end-date' => endDate,
  ids: 'channel==' + channelId,
  dimensions: 'day',
  metrics: 'estimatedMinutesWatched'
  filters: 'video==' + videoId
})
puts visitCount.inspect
puts visitCount.data.column_headers.map { |c|
  c.name
}.join("\t")
puts "-----------------"
visitCount.data.rows.sort_by{|a,b| Date.parse(a)}.each do |r|
  puts r.inspect
end

