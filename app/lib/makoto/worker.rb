module Makoto
  class Worker
    include Sidekiq::Worker
    include Package

    def mastodon
      unless @mastodon
        @mastodon = Mastodon.new(config['/mastodon/url'], config['/mastodon/token'])
        @mastodon.mulukhiya_enable = true
      end
      return @mastodon
    end

    def visibility
      return config['/mastodon/visibility']
    end

    def perform
      raise Ginseng::ImplementError, "'#{__method__}' not implemented"
    end
  end
end
