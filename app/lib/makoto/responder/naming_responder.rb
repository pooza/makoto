module Makoto
  class NamingResponder < Responder
    def executable?
      pattern = Regexp.new(@config['/respond/naming/pattern'])
      return false unless matches = @params['content'].match(pattern)
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
