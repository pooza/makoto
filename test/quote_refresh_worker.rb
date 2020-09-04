module Makoto
  class QuoteRefreshWorkerTest < TestCase
    def setup
      @worker = QuoteRefreshWorker.new
    end

    def test_perform
      @worker.perform
    end
  end
end
