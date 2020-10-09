module Makoto
  class MakotoBirthdayLiveEndMonologueWorkerTest < TestCase
    def setup
      @worker = MakotoBirthdayLiveEndMonologueWorker.new
    end

    def test_perform
      @worker.perform
    end
  end
end
