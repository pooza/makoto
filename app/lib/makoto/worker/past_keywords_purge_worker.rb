module Makoto
  class PastKeywordsPurgeWorker < Worker
    sidekiq_options retry: false

    def perform
      PastKeyword.purge
    end
  end
end
