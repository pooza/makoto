module Makoto
  class NamingResponder < Responder
    def executable?
      return false unless matches = analyzer.match(@config['/respond/naming/pattern'])
      @name = matches[1]
      return @name.present?
    end

    def favorability
      return rand(0..1)
    end

    def message
      return @config['/respond/naming/response/friendry'] % [@name] if account.friendry?
      return @config['/respond/naming/response/normal'] % [@name]
    end

    def exec
      account.update(nickname: @name)
      return {
        paragraphs: [message],
      }
    end
  end
end
