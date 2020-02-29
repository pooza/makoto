module Makoto
  class KeywordResponderTest < Test::Unit::TestCase
    def setup
      @responder = KeywordResponder.new
    end

    def test_exec
      @responder.params = {'content' => 'おはようございます。'}
      assert_false(@responder.executable?)

      @responder.params = {'content' => 'ヒーリングっど♥プリキュア、楽しみですね〜'}
      assert(@responder.executable?)
      assert(@responder.exec.present?)
    end
  end
end
