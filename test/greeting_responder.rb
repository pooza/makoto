module Makoto
  class GreetingResponderTest < Test::Unit::TestCase
    def setup
      @responder = GreetingResponder.new
      @config = Config.instance
      @account = {'display_name' => 'ぷーざ', 'acct' => @config['/test/acct']}
    end

    def test_exec
      assert_raise Ginseng::NotFoundError do
        @responder.params = {'content' => '博多ラーメン！', 'account' => @account}
        @responder.executable?
      end

      @responder.params = {'content' => 'おはよう！', 'account' => @account}
      Timecop.travel(Time.parse('8:00'))
      assert(@responder.executable?)
      assert(@responder.on_time?)
      assert(@responder.exec.present?)
      Timecop.travel(Time.parse('17:00'))
      assert(@responder.executable?)
      assert_false(@responder.on_time?)
      assert(@responder.exec.present?)

      Timecop.travel(Time.parse('8:00'))
      @responder.params = {'content' => 'おはようモフ', 'account' => @account}
      assert(@responder.executable?)
      @responder.params = {'content' => 'おはようでプルンス', 'account' => @account}
      assert(@responder.executable?)
      assert_raise Ginseng::NotFoundError do
        @responder.params = {'content' => 'おはようさん', 'account' => @account}
        @responder.executable?
      end
      assert_raise Ginseng::NotFoundError do
        @responder.params = {'content' => 'おはようのプルンス', 'account' => @account}
        @responder.executable?
      end

      @responder.params = {'content' => 'あけおめ！', 'account' => @account}
      Timecop.travel(Time.parse('2000/1/1'))
      assert(@responder.executable?)
      assert(@responder.on_time?)
      assert(@responder.exec.present?)
      Timecop.travel(Time.parse('2000/1/8'))
      assert(@responder.executable?)
      assert_false(@responder.on_time?)
      assert(@responder.exec.present?)
    end
  end
end
