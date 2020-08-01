module Makoto
  class LocalDictionaryRefreshWorker < Worker
    sidekiq_options retry: false

    def perform
      dic = LocalDictionary.new
      dic.refresh
      dic.install
    end
  end
end
