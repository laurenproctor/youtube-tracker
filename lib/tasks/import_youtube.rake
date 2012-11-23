task :import_youtube => :environment do
  SyncChannel.import_channels
  SyncFacebookInfo.import_facebook_infos
  SyncTwitterInfo.import_twitter_infos

  SyncStatus.import_statuses
  SyncPlaylist.import_playlists

  SyncVideo.import_videos

  SyncVideo.import_detail_videos
  SyncVideo.track_videos
  SyncPlaylist.track_playlists
end

