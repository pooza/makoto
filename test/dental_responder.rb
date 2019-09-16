module Makoto
  class DentalResponderTest < Test::Unit::TestCase
    def setup
      @responder = DentalResponder.new
    end

    def test_exec
      @responder.params = {'content' => 'ばっちしバシシ'}
      assert_false(@responder.executable?)

      @responder.params = {'content' => '歯医者'}
      assert(@responder.executable?)
      assert(@responder.exec.present?)
    end
  end
end
