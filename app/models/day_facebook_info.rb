class DayFacebookInfo < ActiveRecord::Base
  attr_accessible :facebook_info_id, :imported_date, :likes, :talking_about_count, :unique_id, :report_date
  belongs_to :facebook_info

  def data_date
    self.imported_date.getlocal - 1.day
  end
end

