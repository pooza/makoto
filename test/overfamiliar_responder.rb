module Makoto
  class OverfamiliarResponderTest < TestCase
    def setup
      @responder = OverfamiliarResponder.new
    end

    def test_executable?
      @responder.params = {'content' => 'アン'}
      assert(@responder.executable?)

      @responder.params = {'content' => 'アンジュ'}
      assert(@responder.executable?)

      @responder.params = {'content' => 'アンテナ'}
      assert(@responder.executable?)

      @responder.params = {'content' => 'キュアアンジュ'}
      assert(@responder.executable?)

      @responder.params = {'content' => 'アン王女', 'mention' => true}
      assert_false(@responder.executable?)

      @responder.params = {'content' => 'アン殿下', 'mention' => true}
      assert_false(@responder.executable?)

      assert_raise MatchingError do
        @responder.params = {'content' => 'アン殿下'}
        @responder.executable?
      end
    end

    def test_continue?
      assert_false(@responder.continue?)
    end

    def test_exec
      assert_kind_of(Array, @responder.exec)
    end
  end
end
