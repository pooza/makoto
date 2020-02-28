require 'sanitize'
require 'unicode'
require 'natto'

module Makoto
  class Responder
    attr_reader :params

    def initialize
      @config = Config.instance
      @logger = Logger.new
      @params = {}
    end

    def underscore_name
      return self.class.to_s.split('::').last.sub(/Responder$/, '').underscore
    end

    def params=(params)
      @params = params
      @params['content'] = Responder.sanitize(@params['content'])
    end

    def executable?
      raise Ginseng::ImplementError, "'#{__method__}' not implemented"
    end

    def exec
      raise Ginseng::ImplementError, "'#{__method__}' not implemented"
    end

    def favorability
      return nil
    end

    def account
      @account ||= Account.get(params['account']['acct'])
      return @account
    rescue
      return nil
    end

    def analyze
      words = {}
      Natto::MeCab.new.parse(create_source_text(@params['content'])) do |word|
        surface = Responder.sanitize(word.surface)
        features = word.feature.split(',')
        pattern = Regexp.new('(' + @config['/respond/keyword/ignore_features'].join('|') + ')')
        next unless features.member?('名詞')
        next if ignore_words.member?(surface)
        next if pattern.match?(features.join('|'))
        feature = '一般'
        ['人名', '地域'].each do |v|
          feature = v if features.member?(v)
        end
        words[surface] = {surface: surface, feature: feature}
      end
      return words.values
    end

    def self.all
      return enum_for(__method__) unless block_given?
      Config.instance['/respond/classes'].each do |v|
        yield "Makoto::#{v.classify}Responder".constantize.new
      end
    end

    def self.sanitize(message)
      message = Sanitize.clean(message)
      message = Unicode.nfkc(message)
      message.strip!
      return message
    end

    def self.respondable?(payload)
      config = Config.instance
      return false if config['/respond/ignore_accounts'].member?(payload['account']['acct'])
      content = sanitize(payload['content'])
      return false if content.match(Regexp.new("@#{config['/mastodon/account/name']}(\\s|$)"))
      Keyword.dataset.where(type: 'topic').all do |topic|
        return true if content.include?(topic.word)
      end
      return false
    end

    private

    def ignore_words
      @ignore_words ||= Keyword.dataset.where(type: 'ignore').all.map(&:word)
      return @ignore_words
    end

    def create_source_text(text)
      temp = text.clone
      text.scan(%r{https?://[^\s[:cntrl:]]+}).each do |link|
        temp.gsub!(link, '')
      end
      Ginseng::TagContainer.scan(text).each do |tag|
        temp.gsub!(Mastodon.create_tag(tag), '')
      end
      return temp
    end
  end
end
