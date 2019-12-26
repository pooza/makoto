module Makoto
  class GreetingResponderTest < Test::Unit::TestCase
    def setup
      @responder = GreetingResponder.new
      @config = Config.instance
    end

    def test_exec
      @responder.params = {
        'content' => '博多ラーメン！',
        'account' => {'display_name' => 'ぷーざ', 'acct' => @config['/test/acct']},
      }
      assert_false(@responder.executable?)

      Timecop.travel(Time.parse('8:00'))
      @responder.params = {
        'content' => 'おはよう！',
        'account' => {'display_name' => 'ぷーざ', 'acct' => @config['/test/acct']},
      }
      assert(@responder.executable?)
      assert(@responder.on_time?)
      assert(@responder.exec.present?)

      Timecop.travel(Time.parse('17:00'))
      @responder.params = {
        'content' => 'おはよう！',
        'account' => {'display_name' => 'ぷーざ', 'acct' => @config['/test/acct']},
      }
      assert(@responder.executable?)
      assert_false(@responder.on_time?)
      assert(@responder.exec.present?)

      Timecop.travel(Time.parse('2000/1/1'))
      @responder.params = {
        'content' => 'あけおめ！',
        'account' => {'display_name' => 'ぷーざ', 'acct' => @config['/test/acct']},
      }
      assert(@responder.executable?)
      assert(@responder.on_time?)
      assert(@responder.exec.present?)

      Timecop.travel(Time.parse('2000/1/8'))
      @responder.params = {
        'content' => 'あけおめ！',
        'account' => {'display_name' => 'ぷーざ', 'acct' => @config['/test/acct']},
      }
      assert(@responder.executable?)
      assert_false(@responder.on_time?)
      assert(@responder.exec.present?)
    end
  end
end
