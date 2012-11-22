class SyncPlaylist

  class << self
    def import_playlists
      Channel.find_each() do |p|
        Playlist.search_import p
      end
    end

    def track_playlists
      Channel.find_each() do |p|
        DayPlaylistTracker.track p
      end
    end

  end
end

