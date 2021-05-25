module Makoto
  class InterestedResponderTest < TestCase
    def setup
      @responder = InterestedResponder.new
    end

    def test_executable?
      @responder.params = {'content' => '王女様！', 'account' => test_account}
      assert(@responder.executable?)
      assert(@responder.exec.present?)

      @responder.params = {'content' => 'ばっちしバシシ', 'account' => test_account}
      assert_false(@responder.executable?)

      @responder.params = {'content' => '歯医者', 'account' => test_account}
      assert(@responder.executable?)
      assert(@responder.exec.present?)

      assert_raise MatchingError do
        @responder.params = {'content' => '歌', 'account' => test_account}
        @responder.executable?
      end
      @responder.params = {'content' => '歌', 'mention' => true, 'account' => test_account}
      assert_false(@responder.executable?)

      @responder.params = {'content' => '歌う', 'account' => test_account}
      assert(@responder.executable?)
      assert(@responder.exec.present?)
    end

    def test_continue?
      assert_boolean(@responder.continue?)
    end

    def test_exec
      @responder.exec
      assert(@responder.paragraphs.present?)
    end
  end
end
