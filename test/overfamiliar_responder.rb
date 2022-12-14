module Makoto
  class OverfamiliarResponderTest < TestCase
    def setup
      @responder = OverfamiliarResponder.new
    end

    def test_executable?
      @responder.params = {'content' => 'アン', 'account' => test_account}

      assert_predicate(@responder, :executable?)

      @responder.params = {'content' => 'アンジュ', 'account' => test_account}

      assert_predicate(@responder, :executable?)

      @responder.params = {'content' => 'アンテナ', 'account' => test_account}

      assert_predicate(@responder, :executable?)

      @responder.params = {'content' => 'キュアアンジュ', 'account' => test_account}

      assert_predicate(@responder, :executable?)

      @responder.params = {'content' => 'アン王女', 'mention' => true, 'account' => test_account}

      assert_false(@responder.executable?)

      @responder.params = {'content' => 'アン殿下', 'mention' => true, 'account' => test_account}

      assert_false(@responder.executable?)

      assert_raise MatchingError do
        @responder.params = {'content' => 'アン殿下', 'account' => test_account}
        @responder.executable?
      end
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
