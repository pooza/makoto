module Makoto
  class MakotoBirthdayMonologueWorkerTest < TestCase
    def setup
      @worker = MakotoBirthdayMonologueWorker.new
    end

    def test_perform
      @worker.perform
    end
  end
end
