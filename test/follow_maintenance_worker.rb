module Makoto
  class FollowMaintenanceWorkerTest < Test::Unit::TestCase
    def setup
      @worker = FollowMaintenanceWorker.new
    end

    def test_perform
      return if Environment.ci?
      @worker.perform
      assert_kind_of(Array, @worker.follower_ids)
      assert_kind_of(Array, @worker.followee_ids)
    end
  end
end
