module Makoto
  class QuoteDictionaryWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def initialize
      @logger = Logger.new
    end

    def perform
      QuoteDictionary.new.refresh
    rescue => e
      @logger.error(e)
    end
  end
end
