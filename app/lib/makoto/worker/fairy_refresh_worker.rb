module Makoto
  class FairyRefreshWorker < Worker
    sidekiq_options retry: false

    def perform
      Fairy.refresh
    end
  end
end
