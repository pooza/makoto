module Makoto
  class PrincessResponderTest < Test::Unit::TestCase
    def setup
      @responder = PrincessResponder.new
    end

    def test_exec
      @responder.params = {'content' => '王女'}
      assert_false(@responder.executable?)

      @responder.params = {'content' => '王女様！'}
      assert(@responder.executable?)
      assert(@responder.exec.present?)
    end
  end
end
