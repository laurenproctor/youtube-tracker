class TimeUtil
  class << self
    def today
      Time.zone.today.to_datetime
    end

    def now
      Time.zone.now
    end
  end
end

