module Makoto
  class GoodQuoteMonologueWorkerTest < TestCase
    def setup
      @worker = GoodQuoteMonologueWorker.new
    end

    def test_perform
      @worker.perform
    end
  end
end
