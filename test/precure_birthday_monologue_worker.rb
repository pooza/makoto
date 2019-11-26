module Makoto
  class PrecureBirthdayMonologueWorkerTest < Test::Unit::TestCase
    def setup
      @worker = PrecureBirthdayMonologueWorker.new
    end

    def test_perform
      return if Environment.ci?
      @worker.perform
    end
  end
end
