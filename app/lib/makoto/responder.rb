require 'sanitize'
require 'unicode'

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
      @config["/respond/#{underscore_name}/words"].each do |word|
        return true if @params['content'].include?(word)
      end
      return false
    end

    def exec
      raise Ginseng::ImplementError, "'#{__method__}' not implemented"
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
