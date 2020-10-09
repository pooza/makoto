module Makoto
  class MakotoBirthdayLiveStartMonologueWorkerTest < TestCase
    def setup
      @worker = MakotoBirthdayLiveStartMonologueWorker.new
    end

    def test_perform
      @worker.perform
    end
  end
end
