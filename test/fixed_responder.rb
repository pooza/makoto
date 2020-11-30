module Makoto
  class FixedResponderTest < TestCase
    def setup
      @responder = FixedResponder.new
    end

    def test_executable?
      @responder.params = {'content' => ''}
      assert(@responder.executable?)
      assert(@responder.exec.present?)
    end

    def test_continue?
      assert_false(@responder.continue?)
    end

    def test_exec
      assert_kind_of(Array, @responder.exec)
    end
  end
end
