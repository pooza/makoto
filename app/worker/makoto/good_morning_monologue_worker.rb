require 'time'

module Makoto
  class GoodMorningMonologueWorker < Worker
    sidekiq_options retry: 3

    def perform
      template = Template.new('good_morning')
      template[:greeting] = holiday_greeting
      template[:topic] = topic unless template[:greeting]
      mastodon.toot(template.to_s)
    end

    def topic
      return @config['/morning/topics'].sample(random: Random.create)
    end

    def holiday_greeting
      @config['/holidays'].each do |holiday|
        next unless holiday['date'] == Time.now.strftime('%m%d')
        return holiday['greeting']
      end
      return nil
    end
  end
end
