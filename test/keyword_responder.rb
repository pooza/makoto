module Makoto
  class KeywordResponderTest < TestCase
    def setup
      @responder = KeywordResponder.new
    end

    def test_executable?
      @responder.clear
      @responder.params = {'content' => 'おはようございます。', 'account' => test_account}
      assert_false(@responder.executable?)

      @responder.clear
      @responder.params = {'content' => 'ヒーリングっど♥プリキュア、楽しみですね〜', 'account' => test_account}
      assert(@responder.executable?)
      assert(@responder.exec.present?)

      @responder.clear
      @responder.params = {'content' => 'https://www.toei-anim.co.jp/tv/precure5_gogo/episode/summary/48/', 'account' => test_account}
      assert(@responder.executable?)
      assert(@responder.exec.present?)
    end

    def test_continue?
      assert_boolean(@responder.continue?)
    end

    def test_exec
      @responder.clear
      @responder.params = {'content' => 'ヒーリングっど♥プリキュア、楽しみですね〜', 'account' => test_account}
      @responder.exec
      assert(@responder.paragraphs.present?)
    end
  end
end
