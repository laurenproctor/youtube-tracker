class SyncTwitterInfo

  class << self

    def import_twitter_infos
      Channel.find_each() do |p|
        TwitterInfo.search_import(p)
      end
    end

  end
end

