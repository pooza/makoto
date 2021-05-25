module Makoto
  class NamingResponderTest < TestCase
    def setup
      @responder = NamingResponder.new
    end

    def test_executable?
      @responder.params = {'content' => '博多ラーメン！', 'account' => test_account}
      assert_false(@responder.executable?)

      @responder.params = {'content' => '「ぷーざ」って呼んで！', 'account' => test_account}
      assert(@responder.executable?)

      @responder.params = {'content' => '「ぷーざ」って呼んで。', 'account' => test_account}
      assert(@responder.executable?)
    end

    def test_continue?
      assert_false(@responder.continue?)
    end
  end
end
