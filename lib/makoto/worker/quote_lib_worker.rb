module Makoto
  class QuoteLibWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def initialize
      @logger = Logger.new
    end

    def perform
      QuoteLib.new.refresh
    rescue => e
      @logger.error(e)
    end
  end
end
