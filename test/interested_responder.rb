module Makoto
  class InterestedResponderTest < TestCase
    def setup
      @responder = InterestedResponder.new
    end

    def test_exec
      @responder.params = {'content' => '王女様！'}
      assert(@responder.executable?)
      assert(@responder.exec.present?)

      @responder.params = {'content' => 'ばっちしバシシ'}
      assert_false(@responder.executable?)

      @responder.params = {'content' => '歯医者'}
      assert(@responder.executable?)
      assert(@responder.exec.present?)

      assert_raise MatchingError do
        @responder.params = {'content' => '歌'}
        @responder.executable?
      end
      @responder.params = {'content' => '歌', 'mention' => true}
      assert_false(@responder.executable?)

      @responder.params = {'content' => '歌う'}
      assert(@responder.executable?)
      assert(@responder.exec.present?)
    end
  end
end
