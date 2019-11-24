module Makoto
  class GreetingResponderTest < Test::Unit::TestCase
    def setup
      @responder = GreetingResponder.new
      @config = Config.instance
    end

    def test_exec
      return if Environment.ci?

      @responder.params = {
        'content' => '博多ラーメン！',
        'account' => {'display_name' => 'ぷーざ', 'acct' => @config['/test/acct']},
      }
      assert_false(@responder.executable?)

      return if Environment.ci?
      @responder.params = {
        'content' => 'おはよう！',
        'account' => {'display_name' => 'ぷーざ', 'acct' => @config['/test/acct']},
      }
      assert(@responder.executable?)
      assert(@responder.exec.present?)
    end
  end
end
