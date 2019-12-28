module Makoto
  class NewYearMonologueWorkerTest < Test::Unit::TestCase
    def setup
      @worker = NewYearMonologueWorker.new
    end

    def test_perform
      return if Environment.ci?
      @worker.perform
    end
  end
end
