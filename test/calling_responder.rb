module Makoto
  class CallingResponderTest < TestCase
    def setup
      @responder = CallingResponder.new
      @responder.params = {'content' => 'えええええ', 'account' => test_account}
    end

    def test_executable?
      assert_boolean(@responder.executable?)
    end

    def test_exec
      assert_predicate(@responder.exec, :present?)
    end

    def test_continue?
      assert_boolean(@responder.continue?)
    end
  end
end
