module Makoto
  class Analyzer
    include Package
    attr_reader :source

    def initialize(source = nil)
      self.source = source
    end

    def source=(source)
      source ||= ''
      @source = Analyzer.create_source(source.dup)
      @parser = Ginseng::Fediverse::TootParser.new(source.dup)
      @result = nil
      @words = nil
    end

    def result
      unless @result
        @result = {}
        surfaces do |surface|
          @result[surface[:surface]] = surface
        end
        @parser.accts.each do |acct|
          next if acct.username == config['/mastodon/account/name']
          @result[acct.username] = {surface: acct.username, feature: '人名'}
        end
      end
      return @result.values
    end

    def words
      @words ||= result.select {|v| v[:feature].present?}.map {|v| v[:surface]}
      return @words
    end

    def surfaces
      return enum_for(__method__) unless block_given?
      Natto::MeCab.new.parse(@source) do |word|
        features = word.feature.split(',').select {|v| v.strip.present?}
        next if ignore_words.member?(word.surface)
        next if ignore_features_pattern.match?(features.join('|'))
        entry = {surface: word.surface, feature: analyze_feature(features), features:}
        yield entry
      end
    end

    def match?(pattern)
      return @source.match?(pattern)
    end

    def match(pattern)
      return @source.match(pattern)
    end

    def self.create_source(text)
      http = HTTP.new
      http.retry_limit = 1
      text = sanitize(text)
      body = []
      parser = Ginseng::Fediverse::TootParser.new(text)
      parser.uris.each do |uri|
        text.gsub!(uri.to_s, '')
        nokogiri = http.get(uri).body.encode('UTF-8').nokogiri
        body.concat(nokogiri.xpath('//h1').map(&:inner_text))
        body.concat(nokogiri.xpath('//title').map(&:inner_text))
      rescue => e
        logger.error(error: e)
      end
      parser.tags.each do |tag|
        text.gsub!(tag.to_hashtag, '')
      end
      body.push(text)
      return body.join('::::').strip
    end

    def self.sanitize(text)
      return text.to_s.sanitize.nfkc.strip
    end

    def self.respondable?(payload)
      return false if payload['reblog']
      return false if payload['spoiler_text'].present?
      return false if config['/analyzer/ignore_accounts'].member?(payload['account']['acct'])
      text = create_source(payload['content'])
      return false if text.match?("@#{config['/mastodon/account/name']}([[:blank:]]|$)")
      Keyword.dataset.where(type: 'topic').all do |topic|
        return true if text.include?(topic.word)
      end
      return false
    end

    private

    def ignore_words
      @ignore_words ||= Keyword.dataset.where(type: 'ignore').all.map(&:word)
      return @ignore_words
    end

    def ignore_features_pattern
      return Regexp.new("(#{config['/analyzer/ignore_features'].join('|')})")
    end

    def analyze_feature(features)
      return ['人名', '地域', '一般'].find {|v| features.member?(v)}
    end
  end
end
