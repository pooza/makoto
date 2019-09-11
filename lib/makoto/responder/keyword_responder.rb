module Makoto
  class KeywordResponder < Responder
    def initialize
      super
      @paragraphs = []
    end

    def executable?
      words = analyze(@params['content']).shuffle
      templates = @config['/respond/templates'].shuffle
      [rand(1..@config['/respond/paragraph/max']), words.count, templates.count].min.times do
        @paragraphs.push(templates.pop % [words.pop])
        break if @paragraphs.last.match(/[！？!?]$/)
      end
      return @paragraphs.present?
    end

    def exec
      return @paragraphs.join
    end

    def analyze(message)
      words = @config['/word/topics'].clone.keep_if{|v| message.include?(v)}
      words.concat(TagContainer.scan(message))
      words -= @config['/word/ignore']
      words.concat(morph(message)) unless words.present?
      words -= @config['/word/ignore']
      return words.uniq
    end

    def morph(message)
      words = []
      body = {app_id: @config['/goo/app_id'], sentence: message}
      r = HTTP.new.post(@config['/goo/morph/url'], {body: body.to_json}).parsed_response
      r['word_list'].each do |clause|
        clause.each do |word|
          next unless word[1] == '名詞'
          next if word.first.length < @config['/word/length/min']
          words.push(word.first)
        end
      end
      return words.uniq
    end
  end
end
