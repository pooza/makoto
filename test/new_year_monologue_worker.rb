module Makoto
  class NewYearMonologueWorkerTest < TestCase
    def setup
      @worker = NewYearMonologueWorker.new
    end

    def test_perform
      @worker.perform
    end
  end
end
