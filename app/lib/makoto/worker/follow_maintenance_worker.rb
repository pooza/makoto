module Makoto
  class FollowMaintenanceWorker < Worker
    sidekiq_options retry: false

    def perform
      follower_ids.each do |id|
        mastodon.follow(id) unless followee_ids.member?(id)
      rescue => e
        logger.error(error: e, follow: id)
      end
      followee_ids.each do |id|
        mastodon.unfollow(id) unless follower_ids.member?(id)
      rescue => e
        logger.error(error: e, unfollow: id)
      end
    end

    def follower_ids
      @follower_ids ||= mastodon.followers.parsed_response.map {|v| v['id'].to_i}
      return @follower_ids
    end

    def followee_ids
      @followee_ids ||= mastodon.followees.parsed_response.map {|v| v['id'].to_i}
      return @followee_ids
    end
  end
end
