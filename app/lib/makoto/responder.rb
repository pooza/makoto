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
      source = @params['content']
      @params['content'].scan(%r{https?://[^\s[:cntrl:]]+}).each {|link| source.gsub!(link, '')}
      Natto::MeCab.new.parse(source) do |word|
        surface = Responder.sanitize(word.surface)
        features = word.feature.split(',')
        next unless features.include?('名詞')
        next if @config['/word/ignore'].include?(surface)
        next if features.join =~ /(サ変接続|接尾|非自立|代名詞|形容動詞語幹)/
        feature = '一般'
        ['人名', '地域'].each do |v|
          feature = v if features.include?(v)
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
      return false if config['/respond/ignore_accounts'].include?(payload['account']['acct'])
      content = sanitize(payload['content'])
      return false if content.match(Regexp.new("@#{config['/mastodon/account/name']}(\\s|$)"))
      config['/word/topics'].each do |topic|
        return true if content.include?(topic)
      end
      return false
    end
  end
end
