module Makoto
  class GoodQuoteMonologueWorkerTest < Test::Unit::TestCase
    def setup
      @worker = GoodQuoteMonologueWorker.new
    end

    def test_perform
      return if Environment.ci?
      @worker.perform
    end
  end
end
