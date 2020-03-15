module Makoto
  class KeywordResponder < Responder
    def initialize
      super
      @paragraphs = []
    end

    def executable?
      templates = {}
      past_words = load.to_a if account
      words = analyze.shuffle
      save(words) if account
      words.concat(past_words) if account
      [rand(2..@config['/respond/paragraph/max']), words.count].min.times do
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

    private

    def load
      return enum_for(__method__) unless block_given?
      return unless account.past_keyword.present?
      rand(0..1).times do
        yield account.past_keyword.sample
      end
    end

    def save(words)
      Postgres.instance.connection.transaction do
        words.each do |word|
          PastKeyword.create(
            account_id: account.id,
            surface: word[:surface],
            feature: word[:feature],
            created_at: Time.new,
          )
        end
      end
    end
  end
end
