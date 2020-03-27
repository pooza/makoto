module Makoto
  class NamingResponder < Responder
    def executable?
      return false unless matches = analyzer.match(@config['/respond/naming/pattern'])
      @name = matches[1]
      return @name.present?
    end

    def favorability
      return 1
    end

    def exec
      account.update(nickname: @name)
      return @config['/respond/naming/response/friendry'] % [@name] if account.friendry?
      return @config['/respond/naming/response/normal'] % [@name]
    end
  end
end
