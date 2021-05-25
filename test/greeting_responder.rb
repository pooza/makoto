module Makoto
  class GreetingResponderTest < TestCase
    def setup
      @responder = GreetingResponder.new
      @account = {'display_name' => 'ぷーざ', 'acct' => config['/test/acct']}
    end

    def test_executable?
      @responder.params = {'content' => '博多ラーメン！', 'account' => @account}
      assert_false(@responder.executable?)

      @responder.params = {'content' => 'おはよう', 'account' => @account}
      Timecop.travel(Time.parse('8:00'))
      assert(@responder.executable?)
      assert(@responder.on_time?)
      assert(@responder.exec.present?)
      @responder.params = {'content' => 'おはよう～', 'account' => @account}
      assert(@responder.executable?)
      @responder.params = {'content' => 'おはよう〜', 'account' => @account}
      assert(@responder.executable?)
      Timecop.travel(Time.parse('17:00'))
      assert(@responder.executable?)
      assert_false(@responder.on_time?)
      assert(@responder.exec.present?)

      Timecop.travel(Time.parse('8:00'))
      @responder.params = {'content' => 'おはようモフ', 'account' => @account}
      assert(@responder.executable?)
      @responder.params = {'content' => 'おはようでプルンス', 'account' => @account}
      assert(@responder.executable?)
      @responder.params = {'content' => 'おはようルン！', 'account' => @account}
      assert(@responder.executable?)
      @responder.params = {'content' => 'おはよ', 'account' => @account}
      assert(@responder.executable?)
      @responder.params = {'content' => 'おはよ〜', 'account' => @account}
      assert(@responder.executable?)

      assert_raise MatchingError do
        @responder.params = {'content' => 'おはようさん', 'account' => @account}
        @responder.executable?
      end
      assert_raise MatchingError do
        @responder.params = {'content' => 'おはようのプルンス', 'account' => @account}
        @responder.executable?
      end
      @responder.params = {'content' => 'おはようさん', 'account' => @account, 'mention' => true}
      assert_false(@responder.executable?)
      @responder.params = {'content' => 'おはようのプルンス', 'account' => @account, 'mention' => true}
      assert_false(@responder.executable?)

      @responder.params = {'content' => 'ヒーリングッボイ', 'account' => @account, 'mention' => true}
      assert_false(@responder.executable?)
      @responder.params = {'content' => 'ヒーリングッバイ', 'account' => @account, 'mention' => true}
      assert(@responder.executable?)
      @responder.params = {'content' => 'ヒーリングッバ〜イ', 'account' => @account, 'mention' => true}
      assert(@responder.executable?)

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

    def test_continue?
      assert(@responder.continue?)
    end

    def test_quote_suffixes
      @responder.quote_suffixes
    end
  end
end
