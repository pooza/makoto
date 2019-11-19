module Makoto
  class QuoteRefreshWorker < Worker
    sidekiq_options retry: false

    def perform
      Quote.refresh
    end
  end
end
