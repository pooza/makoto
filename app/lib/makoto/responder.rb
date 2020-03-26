module Makoto
  class Responder
    attr_reader :params

    def initialize
      @config = Config.instance
      @logger = Logger.new
      @params = {}
    end

    def params=(params)
      @params = params
      @params['analyzer'] ||= Analyzer.new(params['content'])
      @account = nil
    end

    def analyzer
      return @params['analyzer']
    end

    def underscore_name
      return self.class.to_s.split('::').last.sub(/Responder$/, '').underscore
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

    def display_name
      name = account.nickname || @params['account']['display_name'].sub(/:$/, ': ')
      name += 'さん' unless account.friendry?
      return name
    end

    def mention?
      return @params['mention'].present?
    rescue
      return false
    end

    def self.all
      return enum_for(__method__) unless block_given?
      Config.instance['/respond/classes'].each do |v|
        yield "Makoto::#{v.classify}Responder".constantize.new
      end
    end
  end
end
