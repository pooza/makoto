module Makoto
  class GoodQuoteMonologueWorker < Worker
    sidekiq_options retry: 3

    def perform
      quote = @quotes.pickup(detail: true, priority: 4, form: @config['/quote/all_forms'])
      template = Template.new('good_quote')
      template[:quote] = quote['quote']
      template[:series] = quote['series']
      template[:episode] = quote['episode']
      mastodon.toot(template.to_s)
    end
  end
end
