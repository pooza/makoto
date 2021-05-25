module Makoto
  class FixedResponderTest < TestCase
    def setup
      @responder = FixedResponder.new
    end

    def test_executable?
      @responder.params = {'content' => '', 'account' => test_account}
      assert(@responder.executable?)
      assert(@responder.exec.present?)
    end

    def test_continue?
      assert_false(@responder.continue?)
    end

    def test_exec
      @responder.exec
      assert(@responder.paragraphs.present?)
    end
  end
end
