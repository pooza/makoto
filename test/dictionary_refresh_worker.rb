module Makoto
  class DictionaryRefreshWorkerTest < Test::Unit::TestCase
    def setup
      @worker = DictionaryRefreshWorker.new
    end

    def test_perform
      return if Environment.ci?
      @worker.perform
    end
  end
end
