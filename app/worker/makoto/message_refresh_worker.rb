module Makoto
  class MessageRefreshWorker < Worker
    sidekiq_options retry: false

    def perform
      Message.refresh
    end
  end
end
