module Makoto
  class NowplayingMonologueWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def initialize
      @config = Config.instance
      @mastodon = Mastodon.new(@config['/mastodon/url'], @config['/mastodon/token'])
      @mastodon.mulukhiya_enable = true
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
    end
  end
end
