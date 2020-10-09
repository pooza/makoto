module Makoto
  class MakotoBirthdayNoticeMonologueWorkerTest < TestCase
    def setup
      @worker = MakotoBirthdayNoticeMonologueWorker.new
    end

    def test_perform
      @worker.perform
    end
  end
end
