module Makoto
  class TrackLibWorkerTest < Test::Unit::TestCase
    def setup
      @worker = TrackLibWorker.new
    end

    def test_perform
      return if Environment.ci?
      @worker.perform
    end
  end
end
