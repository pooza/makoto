module Makoto
  class NowplayingMonologueWorker < Worker
    sidekiq_options retry: 3

    def perform
      template = Template.new('nowplaying')
      track = @tracks.sample(random: create_random)
      if track['makoto'].present?
        template[:greeting] = @config['/nowplaying/messages/self'].sample
      else
        template[:greeting] = @config['/nowplaying/messages/normal'].sample
      end
      template[:url] = track['url']
      mastodon.toot(template.to_s)
    end
  end
end
