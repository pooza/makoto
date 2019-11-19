module Makoto
  class Worker
    include Sidekiq::Worker

    def initialize
      @config = Config.instance
      @logger = Logger.new
      @quotes = Quote.new
      @tracks = Track.new
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
  end
end
