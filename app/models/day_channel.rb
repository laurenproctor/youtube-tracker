class DayChannel < ActiveRecord::Base
  attr_accessible :channel_id, :imported_date, :subscribers, :unique_id, :upload_count,
                  :upload_views, :view_count, :report_date
  belongs_to :channel

  def data_date
    self.imported_date.getlocal - 1.day
  end
end

