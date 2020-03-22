module Makoto
  class ResponderTest < Test::Unit::TestCase
    def setup
      @responder = Responder.new
    end

    def test_sanitize
      assert_equal(Responder.sanitize(' ＡＢＣＤＥ '), 'ABCDE')
      assert_equal(Responder.sanitize('<p>abcde</p>  '), 'abcde')
    end

    def test_planize
      assert_equal(Responder.planize(' @pooza https://www.precure.ml 納豆餃子飴 #MAKOTO '), '@pooza  納豆餃子飴')
    end

    def test_analyze
      @responder.params = {'content' => '@pooza @info @makoto 納豆餃子飴'}
      assert_equal(
        @responder.analyze,
        [
          {feature: '人名', surface: 'pooza'},
          {feature: '人名', surface: 'info'},
          {feature: '一般', surface: '納豆餃子飴'},
        ],
      )
    end
  end
end
