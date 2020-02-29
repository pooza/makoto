module Makoto
  class OverfamiliarResponder < Responder
    def executable?
      pattern = '(%s|%s)(%s)?' % [
        @config['/respond/overfamiliar/patterns/match'].join('|'),
        @config['/respond/overfamiliar/patterns/ignore'].join('|'),
        @config['/respond/overfamiliar/patterns/suffix'].join('|'),
      ]
      return false unless matches = Regexp.new(pattern).match(@params['content'])
      return false if matches[2].present?

      pattern = "(#{@config['/respond/overfamiliar/patterns/ignore'].join('|')})"
      return false if matches[1].match?(pattern)
      return true
    end

    def favorability
      return rand(0..1)
    end

    def exec
      return @config['/respond/overfamiliar/message']
    end
  end
end
