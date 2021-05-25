module Makoto
  class MakotoBirthdayMonologueWorker < Worker
    def perform
      template = Template.new('makoto_birthday')
      template[:greeting] = greetings.sample
      template[:titlecall1] = config['/birthday/titlecalls1'].sample
      template[:titlecall2] = config['/birthday/titlecalls2'].sample
      track = Track.pickup(makoto: true)
      template[:url] = track.url
      template[:intro] = track.intro
      mastodon.toot(status: template.to_s, visibility: visibility)
    end

    def greetings
      return Message.dataset.where(type: 'birthday').all.map(&:message)
    end
  end
end
