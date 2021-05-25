module Makoto
  class MakotoBirthdayLiveStartMonologueWorker < Worker
    def perform
      template = Template.new('makoto_birthday_notice')
      template[:message] = config['/birthday/start']
      mastodon.toot(status: template.to_s, visibility: visibility)
    end
  end
end
