module Makoto
  class GoodMorningMonologueWorkerTest < Test::Unit::TestCase
    def setup
      @worker = GoodMorningMonologueWorker.new
    end

    def test_perform
      return if Environment.ci?
      @worker.perform
    end
  end
end
