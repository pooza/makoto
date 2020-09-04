module Makoto
  class MessageRefreshWorkerTest < TestCase
    def setup
      @worker = MessageRefreshWorker.new
    end

    def test_perform
      @worker.perform
    end
  end
end
