module Makoto
  class RubicureAPIService
    include Package
    include Singleton
    attr_reader :http

    def girls
      @girls ||= @http.get('/v2/girls.json').parsed_response
      return @girls
    end

    def quote_suffixes
      @quote_suffixes ||= girls.filter_map {|v| v['quote_suffixes']}.flatten
      return @quote_suffixes
    end

    def series
      @series ||= @http.get('/v2/series.json').parsed_response
      return @series
    end

    private

    def initialize
      @http = HTTP.new
      @http.base_uri = config['/rubicure/url']
    end
  end
end
