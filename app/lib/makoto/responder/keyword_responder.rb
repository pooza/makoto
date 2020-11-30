module Makoto
  class KeywordResponder < Responder
    def initialize
      super
      @paragraphs = []
    end

    def executable?
      templates = {}
      words = create_word_entries
      words.clone.count.times do
        word = words.pop
        feature = word[:feature]
        records = Message.dataset.where(type: 'template', feature: feature)
        templates[feature] ||= records.all.shuffle
        template = templates[feature].pop.message
        @paragraphs.push(template % [word[:surface]])
      rescue => e
        @logger.error(e)
      end
      return @paragraphs.present?
    end

    def continue?
      return true
    end

    def favorability
      return rand(0..1)
    end

    def exec
      return @paragraphs
    end

    def create_word_entries
      words = analyzer.result.select {|v| v[:feature].present?}
      if account&.past_keyword.present?
        rand(0..2).times do
          word = account.past_keyword.select {|v| v[:feature].present?}.sample
          words.push(word.values) if word
        end
      end
      return words.uniq.shuffle
    end
  end
end
