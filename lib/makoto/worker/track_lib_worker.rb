module Makoto
  class TrackLibWorker < Worker
    sidekiq_options retry: false

    def perform
      TrackLib.new.refresh
    end
  end
end
