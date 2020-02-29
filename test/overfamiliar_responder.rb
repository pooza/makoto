module Makoto
  class OverfamiliarResponderTest < Test::Unit::TestCase
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
      assert_false(@responder.executable?)

      @responder.params = {'content' => 'アン王女'}
      assert_false(@responder.executable?)

      @responder.params = {'content' => 'アン殿下'}
      assert_false(@responder.executable?)
    end
  end
end
