module Makoto
  class BirthdayMonologueWorker < Worker
    def perform
      template = Template.new('birthday')
      template[:greeting] = @config['/birthday/greeting'].sample
      template[:message] = @config['/birthday/messages'].sample
      template[:url] = Track.pickup(makoto: true).url
      template[:intro] = Track.pickup(makoto: true).intro
      mastodon.toot(template.to_s)
    end
  end
end
