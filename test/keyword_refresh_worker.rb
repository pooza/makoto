module Makoto
  class KeywordRefreshWorkerTest < TestCase
    def setup
      @worker = KeywordRefreshWorker.new
    end

    def test_perform
      @worker.perform
    end
  end
end
