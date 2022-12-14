module Makoto
  class BadMoodResponderTest < TestCase
    def setup
      @responder = BadMoodResponder.new
    end

    def test_executable?
      @responder.params = {'content' => 'ネギトロ丼', 'account' => test_account}

      assert_false(@responder.executable?)

      @responder.params = {'content' => 'おちんちん', 'account' => test_account}

      assert_predicate(@responder, :executable?)
      assert_predicate(@responder.exec, :present?)
    end

    def test_continue?
      assert_false(@responder.continue?)
    end

    def test_exec
      @responder.exec

      assert_predicate(@responder.paragraphs, :present?)
    end
  end
end
