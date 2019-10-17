module Makoto
  class Worker
    include Sidekiq::Worker

    def initialize
      @config = Config.instance
      @logger = Logger.new
      @quotes = QuoteLib.new
      @tracks = TrackLib.new
    end

    def mastodon
      unless @mastodon
        @mastodon = Mastodon.new(@config['/mastodon/url'], @config['/mastodon/token'])
        @mastodon.mulukhiya_enable = true
      end
      return @mastodon
    end

    def perform
      raise Ginseng::ImplementError, "'#{__method__}' not implemented"
    end

    def create_random
      return Random.new(Time.now.to_i)
    end
  end
end
