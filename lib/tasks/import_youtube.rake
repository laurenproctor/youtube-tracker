task :import_youtube => :environment do
   Channel.search_import

   Video.search_import
   DayVideoTracker.track

   Playlist.search_import
   DayPlaylistTracker.track

   FacebookInfo.search_import
   TwitterInfo.search_import
end

