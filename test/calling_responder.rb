module Makoto
  class CallingResponderTest < TestCase
    def setup
      @responder = CallingResponder.new
    end

    def test_executable?
      @responder.params = {'content' => 'えええええ'}
      assert_boolean(@responder.executable?)
    end

    def test_continue?
      assert_boolean(@responder.continue?)
    end
  end
end
