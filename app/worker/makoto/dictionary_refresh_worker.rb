module Makoto
  class DictionaryRefreshWorker < Worker
    sidekiq_options retry: false

    def perform
      dic = Makoto::Dictionary.new
      dic.refresh
      dic.install
    end
  end
end
