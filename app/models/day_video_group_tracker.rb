class DayVideoGroupTracker < Tracker
  belongs_to :video
  class << self
      # param date: beginning_of_day
      def top date
        DayVideoGroupTracker.where(:this_week_rank => 1 .. 25, :report_date => date - 3.day .. date).
        order('updated_at desc ').limit(25)

      end

      def track
        today = DayVideo.select('max(report_date) as report_date').map(&:report_date).first
        track_at_date(today)
      end

      def track_at_date(date)
        today = date
        day_videos = DayVideo.where(:report_date => today).order('week_views desc')
        day_videos.each_with_index do |p, index|
          params = {
              :unique_id => p.video.unique_id, :name => p.video.title,
              :this_week_rank => index + 1,
              :total_aggregate_views => p.view_count, :uploaded_at => p.video.uploaded_at,
              :report_date => today, :report_date_wday => today.wday,
              :comments => p.comment_count, :shares => 0, :tracked_date => today + 1.day,
              :video_id => p.video.id, :channel_name => p.video.channel.username_display.titleize
            }
          this_week_days = today.beginning_of_week .. today
          last_week_tracker = DayVideoGroupTracker.find_by_unique_id_and_report_date(p.unique_id,
               today.beginning_of_week - 1.day)
          if today.wday == Date::DAYS_INTO_WEEK[:sunday]
            params[:last_week_rank] = params[:this_week_rank]
          else
            params[:last_week_rank] = last_week_tracker.try(:this_week_rank)
          end

          yesterday_tracker = DayVideoGroupTracker.find_by_unique_id_and_report_date(p.unique_id, today - 1.day)
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
            :report_date => this_week_days).sum('day_view_count')

          ago_7_day_tracker = DayVideoGroupTracker.
            find_by_unique_id_and_report_date(p.unique_id, today - 7.days)
          if ago_7_day_tracker && ago_7_day_tracker.this_week_views != 0
            params[:percent_change_views] =  ( params[:this_week_views] -
              ago_7_day_tracker.this_week_views) *
              100 / ago_7_day_tracker.this_week_views
          else
            params[:percent_change_views] = 0
          end

          params[:peak_position] = DayVideoGroupTracker.
            where(:unique_id => p.unique_id).
            where('trackers.report_date_wday = 0').
            map(&:this_week_rank).min
          params[:trackable] = p
          unless tracker = DayVideoGroupTracker.find_by_unique_id_and_report_date(p.unique_id, today)
            DayVideoGroupTracker.create params
          else
            tracker.update_attributes  params
          end
        end
      end

  end

end

