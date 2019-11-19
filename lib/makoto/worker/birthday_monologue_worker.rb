module Makoto
  class BirthdayMonologueWorker < Worker
    def perform
      template = Template.new('birthday')
      template[:greeting] = @config['/birthday/greeting'].sample
      template[:message] = @config['/birthday/messages'].sample
      track = Track.pickup(makoto: true)
      template[:url] = track.url
      mastodon.toot(template.to_s)
    end
  end
end
