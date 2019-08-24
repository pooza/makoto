module Makoto
  class TrackLibWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def initialize
      @logger = Logger.new
    end

    def perform
      TrackLib.new.refresh
    rescue => e
      @logger.error(e)
    end
  end
end
