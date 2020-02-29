module Makoto
  class KeywordRefreshWorker < Worker
    sidekiq_options retry: false

    def perform
      Keyword.refresh
    end
  end
end
