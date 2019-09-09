module Makoto
  class FollowWorker < Worker
    def perform(params)
      mastodon.follow(params['account_id'].to_i)
    end
  end
end
