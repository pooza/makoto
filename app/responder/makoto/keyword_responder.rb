module Makoto
  class KeywordResponder < Responder
    def initialize
      super
      @paragraphs = []
    end

    def executable?
      templates = {}
      words = analyze.shuffle
      [rand(2..@config['/respond/paragraph/max']), words.count].min.times do
        word = words.pop
        templates[word[:feature]] ||= @config["/respond/templates/#{word[:feature]}"].shuffle
        template = templates[word[:feature]].pop
        @paragraphs.push(template % [word[:surface]])
        break if /[！？!?]$/.match?(template)
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
  end
end
