module Makoto
  class QuoteTest < Test::Unit::TestCase
    def test_pickup
      quote = Quote.pickup
      assert_kind_of(Quote, quote)
      assert_kind_of(String, quote.body)
      assert(quote.body.present?)
    end
  end
end
