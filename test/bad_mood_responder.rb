module Makoto
  class BadMoodResponderTest < Test::Unit::TestCase
    def setup
      @responder = BadMoodResponder.new
      @config = Config.instance
    end

    def test_exec
      return if Environment.ci?
      @responder.params = {
        'content' => 'ネギトロ丼',
        'account' => {'display_name' => 'ぷーざ', 'acct' => @config['/test/acct']},
      }
      assert_false(@responder.executable?)

      @responder.params = {
        'content' => 'ちんこ',
        'account' => {'display_name' => 'ぷーざ', 'acct' => @config['/test/acct']},
      }
      assert(@responder.executable?)
      assert(@responder.exec.present?) unless Environment.ci?
    end
  end
end
