module Makoto
  class InterestedResponder < Responder
    def executable?
      text = Responder.create_source_text(@params['content'])
      @config['/respond/interested'].each do |entry|
        next unless text.include?(entry['quote'])
        entry['words'] ||= [entry['quote']]
        entry['words'].each do |word|
          next unless text.include?(word)
          @keyword = entry['quote']
          return true
        end
        raise Ginseng::NotFoundError, "no match (#{entry['words'].join('|')})"
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
