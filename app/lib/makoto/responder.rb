module Makoto
  class Responder
    include Package
    attr_reader :params, :greetings, :paragraphs

    def initialize
      @params = {}
      @greetings = []
      @paragraphs = []
    end

    def params=(params)
      params.deep_stringify_keys!
      @account = nil
      @params = params
      @params['analyzer'] ||= Analyzer.new(source)
    end

    def clear
      @params = {}
    end

    def analyzer
      return @params['analyzer']
    end

    def underscore
      return self.class.to_s.split('::').last.sub(/Responder$/, '').underscore
    end

    def executable?
      raise Ginseng::ImplementError, "'#{__method__}' not implemented"
    end

    def continue?
      return false
    end

    def exec
      raise Ginseng::ImplementError, "'#{__method__}' not implemented"
    end

    def favorability
      return nil
    end

    def source
      return Analyzer.sanitize(params['content'])
    end

    def account
      @account ||= Account.get(params['account']['acct']) rescue nil
      return @account
    end

    def display_name
      name = account.nickname || @params['account']['display_name'].sub(/:$/, ': ')
      name += 'さん' unless account.friendry?
      return name
    end

    def mention?
      return @params['mention'].present? rescue false
    end

    def self.all
      return enum_for(__method__) unless block_given?
      Config.instance['/respond/classes'].each do |v|
        yield "Makoto::#{v.classify}Responder".constantize.new
      end
    end
  end
end
