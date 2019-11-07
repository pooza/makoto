module Makoto
  class BirthdayMonologueWorkerTest < Test::Unit::TestCase
    def setup
      @worker = BirthdayMonologueWorker.new
    end

    def test_perform
      return if Environment.ci?
      @worker.perform
    end
  end
end
