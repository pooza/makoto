module Makoto
  class FollowMaintenanceWorkerTest < Test::Unit::TestCase
    def setup
      @worker = FollowMaintenanceWorker.new
    end

    def test_perform
      return if Environment.ci?
      @worker.perform
      assert(@worker.follower_ids.is_a?(Array))
      assert(@worker.followee_ids.is_a?(Array))
    end
  end
end
