module Makoto
  class KeywordResponderTest < TestCase
    def setup
      @responder = KeywordResponder.new
    end

    def test_executable?
      @responder.clear
      @responder.params = {'content' => 'おはようございます。'}
      assert_false(@responder.executable?)

      @responder.clear
      @responder.params = {'content' => 'ヒーリングっど♥プリキュア、楽しみですね〜'}
      assert(@responder.executable?)
      assert(@responder.exec.present?)

      @responder.clear
      @responder.params = {'content' => 'https://www.toei-anim.co.jp/tv/precure5_gogo/episode/summary/48/'}
      assert(@responder.executable?)
      assert(@responder.exec.present?)
    end

    def test_continue?
      assert_boolean(@responder.continue?)
    end

    def test_exec
      assert_kind_of(Array, @responder.exec)
    end
  end
end
