module Makoto
  class LocalDictionaryRefreshWorkerTest < TestCase
    def setup
      @worker = LocalDictionaryRefreshWorker.new
    end

    def test_perform
      @worker.perform
    end
  end
end
