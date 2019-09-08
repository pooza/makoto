module Makoto
  class FollowMaintenanceWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def initialize
      @config = Config.instance
      @mastodon = Mastodon.new(@config['/mastodon/url'], @config['/mastodon/token'])
    end

    def perform
      follower_ids = @mastodon.followers.parsed_response.map{|v| v['id']}
      followee_ids = @mastodon.followees.parsed_response.map{|v| v['id']}
      follower_ids.each do |id|
        @mastodon.follow(id) unless followee_ids.include?(id)
      end
      followee_ids.each do |id|
        @mastodon.unfollow(id) unless follower_ids.include?(id)
      end
    end
  end
end
