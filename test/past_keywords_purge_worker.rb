module Makoto
  class PastKeywordsPurgeWorkerTest < Test::Unit::TestCase
    def setup
      @worker = PastKeywordsPurgeWorker.new
    end

    def test_perform
      @worker.perform
    end
  end
end