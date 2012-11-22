class SyncChannel

  class << self
    def import_channels
      %w(officialcomedy networka look).each do |p|
        Channel.search_import YOUTUBE[p.to_sym][:user_id]
      end
    end

  end
end

