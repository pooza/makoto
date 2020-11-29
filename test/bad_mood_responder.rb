module Makoto
  class BadMoodResponderTest < TestCase
    def setup
      @responder = BadMoodResponder.new
      @config = Config.instance
      @account = {'display_name' => 'ぷーざ', 'acct' => @config['/test/acct']}
    end

    def test_exec
      @responder.params = {'content' => 'ネギトロ丼', 'account' => @account}
      assert_false(@responder.executable?)

      @responder.params = {'content' => 'おちんちん', 'account' => @account}
      assert(@responder.executable?)
      assert(@responder.exec.present?)
    end

    def test_continue?
      assert_false(@responder.continue?)
    end
  end
end
