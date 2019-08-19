module Makoto
  class NowplayingMonologueWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def initialize
      @logger = Logger.new
      @config = Config.instance
      @mastodon = Mastodon.new(@config['/mastodon/url'])
      @mastodon.mulukhiya_enable = true
      @mastodon.token = @config['/mastodon/token']
      @http = HTTP.new
    end

    def perform
      @mastodon.toot("#nowplaying #{tracks.to_a.sample}")
    end

    def tracks
      return enum_for(__method__) unless block_given?
      @http.get(@config['/tracks/url']).parsed_response.map do |href|
        yield Ginseng::URI.parse(href)
      rescue => e
        @logger.error(e)
        next
      end
    end
  end
end
