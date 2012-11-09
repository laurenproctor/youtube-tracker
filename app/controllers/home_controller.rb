class HomeController < ApplicationController
  def index
    today = Time.now.beginning_of_day
    @channel = Channel.find_by_username(YOUTUBE[:user_id])
    @top_videos = DayVideoTracker.where(:this_week_rank => 1 .. 25, :tracked_date => today).
      order(sort_column(DayVideoTracker) + " " + sort_direction).limit(25) # .page(params[:page])

    @top_playlists = DayPlaylistTracker.where(:this_week_rank => 1 .. 25, :tracked_date => today).
      order(sort_column(DayPlaylistTracker) + " " + sort_direction).limit(25)
  end
end

