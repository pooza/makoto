module Makoto
  class DictionaryRefreshWorkerTest < Test::Unit::TestCase
    def setup
      @worker = DictionaryRefreshWorker.new
    end

    def test_perform
      @worker.perform
    end
  end
end
