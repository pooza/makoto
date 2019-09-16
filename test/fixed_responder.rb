module Makoto
  class FixedResponderTest < Test::Unit::TestCase
    def setup
      @responder = FixedResponder.new
    end

    def test_exec
      @responder.params = {'content' => ''}
      assert(@responder.executable?)
      assert(@responder.exec.present?)
    end
  end
end
