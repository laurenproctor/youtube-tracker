class DayPlaylistTracker < Tracker
  class << self
      def track
        today = Time.now.beginning_of_day
        day_playlists = DayPlaylist.where(:imported_date => today).order('view_count desc')
        day_playlists.each_with_index do |p, index|
          params = {
              :unique_id => p.playlist.unique_id, :name => p.playlist.title, :this_week_rank => index + 1,
              :total_aggregate_views => p.view_count, :uploaded_at => p.playlist.published_at,
              :comments => p.comment_count, :shares => 0, :tracked_date => today
            }
          this_week_days = today.beginning_of_week .. today
          last_week_tracker = DayPlaylistTracker.find_by_unique_id_and_tracked_date(p.unique_id,
               today.beginning_of_week - 1.day)
          if today.wday == Date::DAYS_INTO_WEEK[:sunday]
            params[:last_week_rank] = params[:this_week_rank]
          else
            params[:last_week_rank] = last_week_tracker.try(:this_week_rank)
          end

          yesterday_tracker = DayPlaylistTracker.find_by_unique_id_and_tracked_date(p.unique_id,
               today - 1.day)
          if params[:this_week_rank] <= 25
            if last_week_tracker.nil? || yesterday_tracker.nil?
              params[:weeks_on_chart] = 1
            elsif last_week_tracker.weeks_on_chart == yesterday_tracker.weeks_on_chart
              params[:weeks_on_chart] = yesterday_tracker.weeks_on_chart + 1
            else
              params[:weeks_on_chart] = yesterday_tracker.weeks_on_chart
            end
          else
            params[:weeks_on_chart] = yesterday_tracker ? yesterday_tracker.weeks_on_chart : 0
          end
          params[:this_week_views] = DayVideo.where(:unique_id => p.unique_id,
            :imported_date => this_week_days).sum('day_view_count')
          if last_week_tracker && last_week_tracker.this_week_views != 0
            params[:weekly_percent_views] =  ( params[:this_week_views] - last_week_tracker.this_week_views) *
              100 / last_week_tracker.this_week_views
          else
            params[:weekly_percent_views] = 0
          end
          params[:videos_in_series] = p.video_count
          unless tracker = DayPlaylistTracker.find_by_unique_id_and_tracked_date(p.unique_id, today)
            DayPlaylistTracker.create params
          else
            tracker.update_attributes  params
          end
        end
      end

  end
end
