module Makoto
  class FollowWorker
    include Sidekiq::Worker

    def initialize
      @logger = Logger.new
      @config = Config.instance
      @mastodon = Mastodon.new(@config['/mastodon/url'])
      @mastodon.token = @config['/mastodon/token']
    end

    def perform(params)
      @mastodon.follow(params['account_id'].to_i)
    end
  end
end
