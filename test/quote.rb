module Makoto
  class QuoteTest < Test::Unit::TestCase
    def test_pickup
      return if Environment.ci?
      quote = Quote.pickup
      assert(quote.is_a?(Quote))
      assert(quote.body.is_a?(String))
      assert(quote.body.present?)
    end
  end
end
