class Goal < ActiveRecord::Base
  attr_accessible :facebook_likes, :subscribers, :time_target, :time_left_days,
                  :view_time, :views, :channel_id

  belongs_to :channel

  validates :facebook_likes, :subscribers,:time_left_days, :presence => true
  validates :view_time, :views, :channel_id, :presence => true
end

