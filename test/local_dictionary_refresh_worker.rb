module Makoto
  class LocalDictionaryRefreshWorkerTest < Test::Unit::TestCase
    def setup
      @worker = LocalDictionaryRefreshWorker.new
    end

    def test_perform
      @worker.perform
    end
  end
end
