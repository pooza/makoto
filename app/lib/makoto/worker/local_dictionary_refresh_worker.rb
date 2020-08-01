module Makoto
  class LocalDictionaryRefreshWorker < Worker
    sidekiq_options retry: 3

    def perform
      dic = LocalDictionary.new
      dic.refresh
      dic.install
    end
  end
end
