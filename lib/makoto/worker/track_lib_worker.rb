module Makoto
  class TrackLibWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform
      TrackLib.new.refresh
    end
  end
end
