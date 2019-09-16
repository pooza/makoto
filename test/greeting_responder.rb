module Makoto
  class GreetingResponderTest < Test::Unit::TestCase
    def setup
      @responder = GreetingResponder.new
    end

    def test_exec
      @responder.params = {'content' => '博多ラーメン！'}
      assert_false(@responder.executable?)

      @responder.params = {
        'content' => 'おはよう！',
        'account' => {'display_name' => 'ぷーざ'},
      }
      assert(@responder.executable?)
      assert(@responder.exec.present?)
    end
  end
end
