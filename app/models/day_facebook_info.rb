class DayFacebookInfo < ActiveRecord::Base
  attr_accessible :facebook_info_id, :imported_date, :likes, :talking_about_count, :unique_id
  belongs_to :facebook_info
end

