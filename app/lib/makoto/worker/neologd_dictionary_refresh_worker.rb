module Makoto
  class NoelogdDictionaryRefreshWorker < Worker
    sidekiq_options retry: 3

    def perform
      dic = NeologdDictionary.new
      dic.refresh
      dic.install
    end
  end
end
