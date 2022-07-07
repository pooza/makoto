module Makoto
  class ResponderTest < TestCase
    def setup
      @responder = Responder.new
    end

    def test_display_name
      @responder.params = {account: {display_name: '吟醸院天才郎', acct: '@pooza@precure.ml'}}
      assert_equal('吟醸院天才郎さん', @responder.display_name)

      @responder.params = {account: {display_name: nil, acct: '@pooza@precure.ml'}}
      assert_equal('@pooza@precure.mlさん', @responder.display_name)

      @responder.params = {account: {display_name: 'ぷーざ :netabare:', acct: '@pooza@precure.ml'}}
      assert_equal('ぷーざ :netabare: さん', @responder.display_name)

      @responder.params = {account: {display_name: 'ぷーざ@キュアスタ！', acct: '@pooza@precure.ml'}}
      assert_equal('ぷーざさん', @responder.display_name)

      @responder.params = {account: {display_name: 'ぷーざ＠キュアスタ！', acct: '@pooza@precure.ml'}}
      assert_equal('ぷーざさん', @responder.display_name)

      @responder.params = {account: {display_name: nil, acct: nil}}
      assert_equal('ジョー岡田さん', @responder.display_name)
    end
  end
end
