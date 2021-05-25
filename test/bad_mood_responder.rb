module Makoto
  class BadMoodResponderTest < TestCase
    def setup
      @responder = BadMoodResponder.new
      @account = {'display_name' => 'ぷーざ', 'acct' => config['/test/acct']}
    end

    def test_executable?
      @responder.params = {'content' => 'ネギトロ丼', 'account' => @account}
      assert_false(@responder.executable?)

      @responder.params = {'content' => 'おちんちん', 'account' => @account}
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
