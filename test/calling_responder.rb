module Makoto
  class CallingResponderTest < Test::Unit::TestCase
    def setup
      @responder = CallingResponder.new
    end

    def test_executable?
      @responder.params = {'content' => 'えええええ'}
      assert_boolean(@responder.executable?)
    end
  end
end
