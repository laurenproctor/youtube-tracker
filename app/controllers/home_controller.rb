class HomeController < ApplicationController
  def index
    @top_videos = DayVideoTracker.where(:this_week_rank => 1 .. 25).
      order(sort_column(DayVideoTracker) + " " + sort_direction).limit(25) # .page(params[:page])

    @top_playlists = DayPlaylistTracker.where(:this_week_rank => 1 .. 25).
      order(sort_column(DayPlaylistTracker) + " " + sort_direction).limit(25)
  end
end

