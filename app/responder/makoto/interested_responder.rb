module Makoto
  class InterestedResponder < Responder
    def executable?
      words = analyze.map{|v| v[:surface]}
      @config['/respond/interested'].each do |entry|
        entry['words'] ||= [entry['quote']]
        entry['words'].each do |word|
          next unless words.include?(word)
          @keyword = entry['quote']
          return true
        end
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
