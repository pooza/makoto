module Makoto
  class QuoteRefreshWorkerTest < Test::Unit::TestCase
    def setup
      @worker = QuoteRefreshWorker.new
    end

    def test_perform
      return if Environment.ci?
      @worker.perform
    end
  end
end
