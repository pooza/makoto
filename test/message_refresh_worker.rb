module Makoto
  class MessageRefreshWorkerTest < Test::Unit::TestCase
    def setup
      @worker = MessageRefreshWorker.new
    end

    def test_perform
      @worker.perform
    end
  end
end
