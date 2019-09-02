module Makoto
  class QuoteLibWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform
      QuoteLib.new.refresh
    end
  end
end
