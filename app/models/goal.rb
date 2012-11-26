class Goal < ActiveRecord::Base
  attr_accessible :facebook_likes, :subscribers, :time_left, :time_left_days, :view_time, :views
end
