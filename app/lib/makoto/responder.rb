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
      unless name = account&.nickname
        if display_name = @params.dig('account', 'display_name')
          name = display_name.split(/[@＠]/).first.sub(/:$/, ': ')
        elsif acct = @params.dig('account', 'acct')
          name = acct
        else
          name = 'ジョー岡田'
        end
      end
      name += config['/respond/suffix'] if Environment.test? || !account.friendry?
      return name
    end

    def mention?
      return @params['mention'].present? rescue false
    end

    def self.all
      return enum_for(__method__) unless block_given?
      config['/respond/classes'].each do |v|
        yield "Makoto::#{v.classify}Responder".constantize.new
      end
    end
  end
end
