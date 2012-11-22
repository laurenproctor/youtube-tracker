class SyncFacebookInfo

  class << self

    def import_facebook_infos
      Channel.find_each() do |p|
        FacebookInfo.search_import(p)
      end
    end

  end
end

