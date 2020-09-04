module Makoto
  class FollowMaintenanceWorkerTest < TestCase
    def setup
      @worker = FollowMaintenanceWorker.new
    end

    def test_perform
      @worker.perform
      assert_kind_of(Array, @worker.follower_ids)
      assert_kind_of(Array, @worker.followee_ids)
    end
  end
end
