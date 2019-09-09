module Makoto
  class QuoteLibWorker < Worker
    sidekiq_options retry: false

    def perform
      QuoteLib.new.refresh
    end
  end
end
