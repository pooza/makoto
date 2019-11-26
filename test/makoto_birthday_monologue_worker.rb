module Makoto
  class MakotoBirthdayMonologueWorkerTest < Test::Unit::TestCase
    def setup
      @worker = MakotoBirthdayMonologueWorker.new
    end

    def test_perform
      return if Environment.ci?
      @worker.perform
    end
  end
end
