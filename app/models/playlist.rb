class Playlist < ActiveRecord::Base
  attr_accessible :description, :playlist_id, :published_at, :response_code, :summary, :title, :xml
end
