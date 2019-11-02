module Makoto
  class BirthdayMonologueWorker < Worker
    def perform
      template = Template.new('birthday')
      mastodon.toot(template.to_s)
    end
  end
end
