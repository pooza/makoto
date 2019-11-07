module Makoto
  class QuoteLibWorkerTest < Test::Unit::TestCase
    def setup
      @worker = QuoteLibWorker.new
    end

    def test_perform
      return if Environment.ci?
      @worker.perform
    end
  end
end
