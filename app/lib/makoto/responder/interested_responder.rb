module Makoto
  class InterestedResponder < MarkovResponder
    def quotes
      dataset = Quote.dataset
        .where(exclude: false, emotion: nil)
        .where(Sequel.like(:body, "%#{@keyword}%") | Sequel.like(:remark, "%#{@keyword}%"))
        .where {3 <= priority}
      return dataset
    end

    def messages
      dataset = Message.dataset
        .where(type: 'morning')
        .where(Sequel.like(:message, "%#{@keyword}%"))
      return dataset
    end

    def executable?
      @config['/respond/interested'].each do |entry|
        next unless analyzer.match?(entry['quote'])
        entry['words'] ||= [entry['quote']]
        entry['words'].each do |word|
          next unless analyzer.match?(word)
          @keyword = entry['quote']
          @table = nil
          return true
        end
        raise MatchingError, "no match (#{entry['words'].join('|')})" unless mention?
        return false
      end
      return false
    end

    def continue?
      return false
    end
  end
end
