module Makoto
  class NowplayingMonologueWorkerTest < Test::Unit::TestCase
    def setup
      @worker = NowplayingMonologueWorker.new
    end

    def test_perform
      return if Environment.ci?
      @worker.perform
    end
  end
end
