module Makoto
  class AnalyzerTest < TestCase
    def setup
      @analyzer = Analyzer.new
    end

    def test_sanitize
      assert_equal('ABCDE', Analyzer.sanitize(' ＡＢＣＤＥ '))
      assert_equal('abcde', Analyzer.sanitize('<p>abcde</p>  '))
    end

    def test_create_source
      source = ' @pooza https://precure.ml 納豆餃子飴 #MAKOTO '

      assert_equal('precure.ml - キュアスタ！::::@pooza  納豆餃子飴', Analyzer.create_source(source))
    end

    def test_analyze
      @analyzer.source = '@pooza @info @makoto 納豆餃子飴'

      assert_equal(['pooza', 'info', '納豆餃子飴'], @analyzer.result.map {|v| v[:surface]})
    end

    def test_respondable?
      return unless word = Keyword.dataset.where(type: 'topic').all.first[:word]
      return unless acct = Ginseng::Fediverse::Acct.new("@#{config['/test/account/acct']}")

      assert_false(Analyzer.respondable?({content: 'fyga', account: {acct: acct.to_s}}))
      assert_false(Analyzer.respondable?({content: word, reblog: true, account: {acct: acct.to_s}}))
      assert_false(Analyzer.respondable?({content: word, spoiler_text: 'ネタバレ', account: {acct: acct.to_s}}))
      assert_false(Analyzer.respondable?({content: "@aaaa #{word}", account: {acct: acct.to_s}}))
      assert(Analyzer.respondable?({content: "#{acct} #{word}", account: {acct: acct.to_s}}))
      assert(Analyzer.respondable?({content: word, account: {acct: acct.to_s}}))
    end
  end
end
