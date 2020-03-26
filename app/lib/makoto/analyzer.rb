require 'natto'
require 'sanitize'
require 'unicode'

module Makoto
  class Analyzer
    attr_reader :source

    def initialize(source = nil)
      @config = Config.instance
      @logger = Logger.new
      self.source = source
    end

    def source=(source)
      @source = Analyzer.create_source(source)
    end

    def result
      unless @result
        @result = {}
        surfaces do |surface|
          @result[surface[:surface]] = surface
        end
        usernames do |username|
          @result[username] = {surface: username, feature: '人名'}
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
        features = word.feature.split(',')
        next if ignore_words.member?(word.surface)
        next if ignore_features_pattern.match?(features.join('|'))
        entry = {surface: word.surface, feature: analyze_feature(features), features: features}
        yield entry
      end
    end

    def usernames
      return enum_for(__method__) unless block_given?
      @source.scan(acct_pattern).each do |acct|
        username = acct.first.sub(/^@/, '').split('@').first
        next if username == @config['/mastodon/account/name']
        yield username
      end
    end

    def match?(pattern)
      return @source.match?(pattern)
    end

    def match(pattern)
      return @source.match(pattern)
    end

    def self.create_source(text)
      text = sanitize(text)
      text.scan(%r{https?://[^\s[:cntrl:]]+}).each do |link|
        text.gsub!(link, '')
      end
      Ginseng::TagContainer.scan(text).each do |tag|
        text.gsub!(Mastodon.create_tag(tag), '')
      end
      return text.strip
    end

    def self.sanitize(text)
      text = Sanitize.clean(text)
      text = Unicode.nfkc(text)
      return text.strip
    end

    def self.respondable?(payload)
      config = Config.instance
      return false if config['/respond/ignore_accounts'].member?(payload['account']['acct'])
      text = create_source(payload['content'])
      return false if text.match?("@#{config['/mastodon/account/name']}(\\s|$)")
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
      return Regexp.new('(' + @config['/respond/keyword/ignore_features'].join('|') + ')')
    end

    def acct_pattern
      return Regexp.new(@config['/mastodon/acct/pattern'], Regexp::IGNORECASE)
    end

    def analyze_feature(features)
      feature = nil
      ['人名', '地域', '一般'].each do |v|
        next unless features.member?(v)
        feature = v
        break
      end
      return feature
    end
  end
end
