module Makoto
  class GreetingResponderTest < TestCase
    def setup
      @responder = GreetingResponder.new
    end

    def test_executable?
      @responder.params = {'content' => '博多ラーメン！', 'account' => test_account}
      assert_false(@responder.executable?)

      @responder.params = {'content' => 'おはよう', 'account' => test_account}
      Timecop.travel(Time.parse('8:00'))
      assert(@responder.executable?)
      assert(@responder.on_time?)
      assert(@responder.exec.present?)
      @responder.params = {'content' => 'おはよう～', 'account' => test_account}
      assert(@responder.executable?)
      @responder.params = {'content' => 'おはよう〜', 'account' => test_account}
      assert(@responder.executable?)
      Timecop.travel(Time.parse('17:00'))
      assert(@responder.executable?)
      assert_false(@responder.on_time?)
      assert(@responder.exec.present?)

      Timecop.travel(Time.parse('8:00'))
      @responder.params = {'content' => 'おはようモフ', 'account' => test_account}
      assert(@responder.executable?)
      @responder.params = {'content' => 'おはようでプルンス', 'account' => test_account}
      assert(@responder.executable?)
      @responder.params = {'content' => 'おはようルン！', 'account' => test_account}
      assert(@responder.executable?)
      @responder.params = {'content' => 'おはよ', 'account' => test_account}
      assert(@responder.executable?)
      @responder.params = {'content' => 'おはよ〜', 'account' => test_account}
      assert(@responder.executable?)

      assert_raise MatchingError do
        @responder.params = {'content' => 'おはようさん', 'account' => test_account}
        @responder.executable?
      end
      assert_raise MatchingError do
        @responder.params = {'content' => 'おはようのプルンス', 'account' => test_account}
        @responder.executable?
      end
      @responder.params = {'content' => 'おはようさん', 'account' => test_account, 'mention' => true}
      assert_false(@responder.executable?)
      @responder.params = {'content' => 'おはようのプルンス', 'account' => test_account, 'mention' => true}
      assert_false(@responder.executable?)

      @responder.params = {'content' => 'ヒーリングッボイ', 'account' => test_account, 'mention' => true}
      assert_false(@responder.executable?)
      @responder.params = {'content' => 'ヒーリングッバイ', 'account' => test_account, 'mention' => true}
      assert(@responder.executable?)
      @responder.params = {'content' => 'ヒーリングッバ〜イ', 'account' => test_account, 'mention' => true}
      assert(@responder.executable?)

      @responder.params = {'content' => 'あけおめ！', 'account' => test_account}
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
      @responder.params = {'content' => 'ヒーリングッバ〜イ', 'account' => test_account, 'mention' => true}
      assert_false(@responder.continue?)

      @responder.params = {'content' => 'おはよう', 'account' => test_account, 'mention' => true}
      assert(@responder.continue?)
    end

    def test_quote_suffixes
      @responder.quote_suffixes
    end
  end
end
