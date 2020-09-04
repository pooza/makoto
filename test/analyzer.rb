module Makoto
  class AnalyzerTest < TestCase
    def setup
      @analyzer = Analyzer.new
    end

    def test_sanitize
      assert_equal(Analyzer.sanitize(' ＡＢＣＤＥ '), 'ABCDE')
      assert_equal(Analyzer.sanitize('<p>abcde</p>  '), 'abcde')
    end

    def test_create_source
      assert_equal(Analyzer.create_source(' @pooza https://www.precure.ml 納豆餃子飴 #MAKOTO '), '@pooza  納豆餃子飴')
    end

    def test_analyze
      @analyzer.source = '@pooza @info @makoto 納豆餃子飴'
      assert_equal(@analyzer.result.map {|v| v[:surface]}, ['pooza', 'info', '納豆餃子飴'])
    end
  end
end
