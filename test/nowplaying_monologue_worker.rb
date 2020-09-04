module Makoto
  class NowplayingMonologueWorkerTest < TestCase
    def setup
      @worker = NowplayingMonologueWorker.new
    end

    def test_perform
      @worker.perform
    end
  end
end
