module Makoto
  class GoodMorningMonologueWorker
    include Sidekiq::Worker
    sidekiq_options retry: 3

    def initialize
      @config = Config.instance
      @mastodon = Mastodon.new(@config['/mastodon/url'], @config['/mastodon/token'])
      @mastodon.mulukhiya_enable = true
    end

    def perform
      @template = Template.new('good_morning')
      @template[:greeting] = @config['/morning/greetings'].sample
      @mastodon.toot(@template.to_s)
    end
  end
end
