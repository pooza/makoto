module Makoto
  class MakotoBirthdayMonologueWorker < Worker
    def perform
      template = Template.new('makoto_birthday')
      template[:greeting] = @config['/birthday/greeting'].sample
      template[:message] = @config['/birthday/messages'].sample
      track = Track.pickup(makoto: true)
      template[:url] = track.url
      template[:intro] = track.intro
      mastodon.toot(template.to_s)
    end
  end
end