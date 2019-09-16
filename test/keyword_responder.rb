module Makoto
  class KeywordResponderTest < Test::Unit::TestCase
    def setup
      @responder = KeywordResponder.new
    end

    def test_exec
      return if Environment.ci?

      @responder.params = {'content' => 'こんにちは。'}
      assert_false(@responder.executable?)

      @responder.params = {'content' => 'ある晴れた昼下がり、市場へ続く道。荷馬車がゴトゴト、子牛を乗せてゆく。'}
      assert(@responder.executable?)
      assert(@responder.exec.present?)
    end
  end
end
