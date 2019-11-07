module Makoto
  class GoodMorningMonologueWorker < Worker
    sidekiq_options retry: 3

    def perform
      template = Template.new('good_morning')
      template[:greeting] = @config['/morning/greetings'].sample(random: Random.create)
      mastodon.toot(template.to_s)
    end
  end
end
