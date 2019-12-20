module Makoto
  class FollowMaintenanceWorker < Worker
    sidekiq_options retry: false

    def perform
      follower_ids.each do |id|
        mastodon.follow(id) unless followee_ids.include?(id)
      rescue => e
        @logger.error(Ginseng::Error.create(e).to_h.merge(follow: id))
      end
      followee_ids.each do |id|
        mastodon.unfollow(id) unless follower_ids.include?(id)
      rescue => e
        @logger.error(Ginseng::Error.create(e).to_h.merge(unfollow: id))
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
