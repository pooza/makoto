module Makoto
  class MakotoBirthdayNoticeMonologueWorker < Worker
    def perform
      template = Template.new('makoto_birthday_notice')
      template[:message] = @config['/birthday/notice']
      mastodon.toot(status: template.to_s, visibility: visibility)
    end
  end
end
