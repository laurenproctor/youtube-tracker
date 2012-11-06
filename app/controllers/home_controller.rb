class HomeController < ApplicationController
  def index
    @top_videos = TopVideo.order(sort_column(TopVideo) + " " + sort_direction) # .page(params[:page])
  end
end

