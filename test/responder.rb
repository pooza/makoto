module Makoto
  class ResponderTest < Test::Unit::TestCase
    def test_sanitize
      assert_equal(Responder.sanitize(' ＡＢＣＤＥ '), 'ABCDE')
      assert_equal(Responder.sanitize('<p>abcde</p>  '), 'abcde')
    end
  end
end
