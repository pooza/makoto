module Makoto
  class RespondWorker
    include Sidekiq::Worker

    def initialize
      @config = Config.instance
      @mastodon = Mastodon.new(@config['/mastodon/url'], @config['/mastodon/token'])
    end

    def perform(params)
      template = Template.new('toot')
      template[:account] = params['account']
      template[:message] = MessageBuilder.new(params).build
      @mastodon.toot(
        status: template.to_s,
        visibility: params['visibility'],
        in_reply_to_id: params['toot_id'],
      )
    end
  end
end
