module Makoto
  class TrackRefreshWorker < Worker
    sidekiq_options retry: false

    def perform
      Track.refresh
    end
  end
end
