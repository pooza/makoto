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
      @track_lib = TrackLib.new
    end

    def perform
      @template = Template.new('nowplaying')
      track = @track_lib.sample
      if track['makoto'].present?
        @template[:greeting] = @config['/nowplaying/messages/self'].sample
      else
        @template[:greeting] = @config['/nowplaying/messages/normal'].sample
      end
      @template[:url] = track['url']
      @mastodon.toot(@template.to_s)
    rescue => e
      @logger.error(e)
    end
  end
end
