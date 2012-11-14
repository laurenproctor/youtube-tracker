namespace :db do
  task :update_db => :environment do
    DayPlaylist.find_each() do |p|
      if p.video_unique_ids.blank?
        p.video_unique_ids = PlaylistVideo.where(:playlist_unique_id => p.unique_id, :imported_date => p.imported_date).map(&:video_unique_id)
        if p.video_unique_ids.blank?
          p.video_unique_ids = PlaylistVideo.where(:playlist_unique_id => p.unique_id, :imported_date => p.imported_date + 1.day).map(&:video_unique_id)
        end
        p.save
      end
    end
  end

end

