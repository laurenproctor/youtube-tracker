class DayChannel < ActiveRecord::Base
  attr_accessible :channel_id, :imported_date, :subscribers, :unique_id, :upload_count, :upload_views, :view_count
  belongs_to :channel
end

