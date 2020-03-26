module Makoto
  class OverfamiliarResponder < Responder
    def executable?
      pattern = '(%s|%s)(%s)?' % [ # rubocop:disable Style/FormatStringToken
        @config['/respond/overfamiliar/patterns/match'].join('|'),
        @config['/respond/overfamiliar/patterns/ignore'].join('|'),
        @config['/respond/overfamiliar/patterns/suffix'].join('|'),
      ]
      return false unless matches = analyzer.match(pattern)
      if matches[2].present?
        return false if mention?
        raise MatchingError, 'no match overfamiliar patterns'
      end

      pattern = "(#{@config['/respond/overfamiliar/patterns/ignore'].join('|')})"
      return false if matches[1].match?(pattern)
      return true
    end

    def favorability
      return rand(0..1) * -1
    end

    def exec
      return @config['/respond/overfamiliar/message']
    end
  end
end
