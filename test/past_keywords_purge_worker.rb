module Makoto
  class PastKeywordsPurgeWorkerTest < TestCase
    def setup
      @worker = PastKeywordsPurgeWorker.new
    end

    def test_perform
      @worker.perform
    end
  end
end
