module Makoto
  class GoodQuoteMonologueWorker < Worker
    sidekiq_options retry: 3

    def initialize
      super
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
      mastodon.toot(template.to_s)
    end
  end
end
