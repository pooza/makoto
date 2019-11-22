module Makoto
  class GoodQuoteMonologueWorker < Worker
    sidekiq_options retry: 3

    def perform
      quote = Quote.pickup(priority: 4, form: @config['/quote/all_forms'])
      template = Template.new('good_quote')
      template[:quote] = quote.body
      template[:series] = Series[quote.series_id].name
      template[:episode] = quote.episode
      mastodon.toot(template.to_s)
    end
  end
end
