namespace :db do
  task :update_db => :environment do
    DayVideo.find_each() do |p|
      tracker = DayVideoTracker.find_by_unique_id_and_tracked_date(p.unique_id, p.imported_date)
      p.tracker = tracker
    end
    DayPlaylist.find_each() do |p|
      tracker = DayPlaylistTracker.find_by_unique_id_and_tracked_date(p.unique_id, p.imported_date)
      p.tracker = tracker
    end
  end

end

