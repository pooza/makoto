module Makoto
  class KeywordResponder < Responder
    def initialize
      super
      @paragraphs = []
    end

    def executable?
      templates = {}
      words = create_word_entries
      [rand(2..@config['/respond/paragraph/max']), words.clone.count].min.times do
        word = words.pop
        feature = word[:feature]
        records = Message.dataset.where(type: 'template', feature: feature)
        templates[feature] ||= records.all.shuffle
        template = templates[feature].pop.message
        @paragraphs.push(template % [word[:surface]])
        break if template.match?(/[！？!?]$/)
      rescue => e
        @logger.error(e)
      end
      return @paragraphs.present?
    end

    def favorability
      return rand(0..1)
    end

    def exec
      return @paragraphs.join
    end

    def create_word_entries
      words = analyzer.result.select {|v| v[:feature].present?}
      if account&.past_keyword.present?
        rand(0..1).times do
          words.push(account.past_keyword.sample)
        end
      end
      return words.shuffle
    end
  end
end
