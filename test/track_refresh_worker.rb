module Makoto
  class TrackRefreshWorkerTest < TestCase
    def setup
      @worker = TrackRefreshWorker.new
    end

    def test_perform
      @worker.perform
    end
  end
end
