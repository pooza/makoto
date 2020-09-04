module Makoto
  class FairyRefreshWorkerTest < TestCase
    def setup
      @worker = FairyRefreshWorker.new
    end

    def test_perform
      @worker.perform
    end
  end
end
