module Makoto
  class InterestedResponderTest < Test::Unit::TestCase
    def setup
      @responder = InterestedResponder.new
    end

    def test_exec
      @responder.params = {'content' => '王女様！'}
      assert(@responder.executable?)
      assert(@responder.exec.present?) unless Environment.ci?

      @responder.params = {'content' => 'ばっちしバシシ'}
      assert_false(@responder.executable?)

      @responder.params = {'content' => '歯医者'}
      assert(@responder.executable?)
      assert(@responder.exec.present?) unless Environment.ci?
    end
  end
end
