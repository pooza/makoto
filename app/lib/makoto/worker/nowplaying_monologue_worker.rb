module Makoto
  class NowplayingMonologueWorker < Worker
    sidekiq_options retry: 3

    def perform
      template = Template.new('nowplaying')
      track = Track.pickup
      if track.makoto?
        template[:greeting] = @config['/nowplaying/messages/self'].sample
      else
        template[:greeting] = @config['/nowplaying/messages/normal'].sample
      end
      template[:url] = track.url
      template[:intro] = track.intro
      template[:tags] = ['#オンエア']
      mastodon.toot(template.to_s)
    end
  end
end
