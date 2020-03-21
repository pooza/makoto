module Makoto
  class InterestedResponder < Responder
    def executable?
      @config['/respond/interested'].each do |entry|
        next unless source_text.include?(entry['quote'])
        entry['words'] ||= [entry['quote']]
        entry['words'].each do |word|
          next unless source_text.include?(word)
          @keyword = entry['quote']
          return true
        end
        raise MatchingError, "no match (#{entry['words'].join('|')})" unless mention?
        return false
      end
      return false
    end

    def favorability
      return 1
    end

    def exec
      quote = Quote.pickup(
        form: @config['/quote/all_forms'],
        keyword: @keyword,
        respond: true,
      )
      raise 'empty' unless quote
      return quote.body
    end
  end
end
