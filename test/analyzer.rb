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
      assert_equal('@pooza  納豆餃子飴', Analyzer.create_source(' @pooza https://www.precure.ml 納豆餃子飴 #MAKOTO '))
    end

    def test_analyze
      @analyzer.source = '@pooza @info @makoto 納豆餃子飴'
      assert_equal(['pooza', 'info', '納豆餃子飴'], @analyzer.result.map {|v| v[:surface]})
    end
  end
end
