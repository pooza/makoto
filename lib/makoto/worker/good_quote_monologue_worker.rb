module Makoto
  class GoodQuoteMonologueWorker
    include Sidekiq::Worker
    sidekiq_options retry: 3

    def initialize
      @config = Config.instance
      @mastodon = Mastodon.new(@config['/mastodon/url'], @config['/mastodon/token'])
      @mastodon.mulukhiya_enable = true
      @quote_lib = QuoteLib.new
    end

    def perform
      quote = @quote_lib.quotes(
        detail: true,
        priority: 4,
        form: ['剣崎真琴', 'キュアソード'],
      ).sample
      template = Template.new('good_quote')
      template[:quote] = quote['quote']
      template[:series] = quote['series']
      template[:episode] = quote['episode']
      @mastodon.toot(template.to_s)
    end
  end
end
