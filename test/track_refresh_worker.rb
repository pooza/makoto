module Makoto
  class TrackRefreshWorkerTest < Test::Unit::TestCase
    def setup
      @worker = TrackRefreshWorker.new
    end

    def test_perform
      return if Environment.ci?
      @worker.perform
    end
  end
end
