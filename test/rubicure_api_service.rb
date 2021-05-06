module Makoto
  class RubicureAPIServiceTest < TestCase
    def setup
      @service = RubicureAPIService.instance
    end

    def test_girls
      assert_kind_of(Array, @service.girls)
      @service.girls.first(5).each do |girl|
        assert_kind_of(Hash, girl)
      end
    end

    def test_quote_suffixes
      assert_kind_of(Array, @service.quote_suffixes)
    end

    def test_series
      assert_kind_of(Array, @service.series)
      @service.series.first(5).each do |series|
        assert_kind_of(Hash, series)
      end
    end
  end
end
