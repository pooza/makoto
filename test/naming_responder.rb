module Makoto
  class NamingResponderTest < TestCase
    def setup
      @responder = NamingResponder.new
      @account = {'display_name' => 'ぷーざ', 'acct' => config['/test/acct']}
    end

    def test_executable?
      @responder.params = {'content' => '博多ラーメン！', 'account' => @account}
      assert_false(@responder.executable?)

      @responder.params = {'content' => '「ぷーざ」って呼んで！', 'account' => @account}
      assert(@responder.executable?)

      @responder.params = {'content' => '「ぷーざ」って呼んで。', 'account' => @account}
      assert(@responder.executable?)
    end

    def test_continue?
      assert_false(@responder.continue?)
    end
  end
end
