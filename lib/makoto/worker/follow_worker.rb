module Makoto
  class FollowWorker
    include Sidekiq::Worker

    def initialize
      @config = Config.instance
      @mastodon = Mastodon.new(@config['/mastodon/url'], @config['/mastodon/token'])
    end

    def perform(params)
      @mastodon.follow(params['account_id'].to_i)
    end
  end
end
