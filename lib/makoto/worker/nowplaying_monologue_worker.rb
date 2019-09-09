module Makoto
  class NowplayingMonologueWorker < Worker
    sidekiq_options retry: false

    def initialize
      super
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
      mastodon.toot(@template.to_s)
    end
  end
end
