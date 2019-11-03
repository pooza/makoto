module Makoto
  class BirthdayMonologueWorker < Worker
    def perform
      template = Template.new('birthday')
      template[:greeting] = @config['/birthday/greeting'].sample
      template[:message] = @config['/birthday/messages'].sample
      template[:url] = @tracks.tracks(makoto: true, detail: true).sample['url']
      mastodon.toot(template.to_s)
    end
  end
end
