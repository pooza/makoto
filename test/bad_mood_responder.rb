module Makoto
  class BadMoodResponderTest < Test::Unit::TestCase
    def setup
      @responder = BadMoodResponder.new
    end

    def test_exec
      @responder.params = {'content' => 'ネギトロ丼'}
      assert_false(@responder.executable?)

      @responder.params = {'content' => 'ちんこ'}
      assert(@responder.executable?)
      assert(@responder.exec.present?)
    end
  end
end
