module Makoto
  class OverfamiliarResponder < Responder
    def executable?
      pattern = '(%s)(%s)?' % [ # rubocop:disable Style/FormatStringToken
        @config['/respond/overfamiliar/patterns/match'].join('|'),
        @config['/respond/overfamiliar/patterns/suffix'].join('|'),
      ]
      return false unless matches = analyzer.match(pattern)
      if matches[2].present?
        return false if mention?
        raise MatchingError, 'no match overfamiliar patterns'
      end
      return true
    end

    def favorability
      return rand(0..1) * -1
    end

    def exec
      return {
        paragraphs: [@config['/respond/overfamiliar/message']],
      }
    end
  end
end
