class DayTwitterInfo < ActiveRecord::Base
  attr_accessible :favourites_count, :followers_count, :friends_count, :imported_date,
                  :listed_count, :statuses_count, :twitter_info_id, :unique_id, :report_date
  belongs_to :twitter_info

  def data_date
    self.imported_date.getlocal - 1.day
  end
end

