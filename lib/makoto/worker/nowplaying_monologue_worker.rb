module Makoto
  class NowplayingMonologueWorker < Worker
    sidekiq_options retry: 3

    def initialize
      super
      @tracks = TrackLib.new
    end

    def perform
      template = Template.new('nowplaying')
      track = @tracks.sample
      template[:greeting] = @config['/nowplaying/messages/normal'].sample
      template[:greeting] = @config['/nowplaying/messages/self'].sample if track['makoto'].present?
      template[:url] = track['url']
      mastodon.toot(template.to_s)
    end
  end
end
