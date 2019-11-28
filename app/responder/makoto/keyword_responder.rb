require 'natto'
require 'unicode'

module Makoto
  class KeywordResponder < Responder
    def initialize
      super
      @paragraphs = []
    end

    def executable?
      words = analyze(@params['content']).shuffle
      templates = @config['/respond/templates'].shuffle
      [rand(2..@config['/respond/paragraph/max']), words.count, templates.count].min.times do
        @paragraphs.push(templates.pop % [words.pop])
        break if @paragraphs.last.match(/[！？!?]$/)
      end
      return @paragraphs.present?
    end

    def favorability
      return rand(0..1)
    end

    def exec
      return @paragraphs.join
    end

    def analyze(message)
      words = @config['/word/topics'].clone.keep_if{|v| message.include?(v)}
      words.concat(Ginseng::TagContainer.scan(message))
      words -= @config['/word/ignore']
      words.concat(morph(message)) unless words.present?
      words -= @config['/word/ignore']
      return words.uniq
    end

    def morph(message)
      words = []
      Natto::MeCab.new.parse(message) do |word|
        features = word.feature.split(',')
        #Slack.broadcast(word: word.surface, fields: fields)
        next unless features.include?('名詞')
        next if features.include?('サ変接続')
        next if features.include?('接尾')
        words.push(Unicode.nfkc(word.surface))
      end
      return words.uniq
    end

    def keywords(message)
      words = []
      body = {app_id: @config['/goo/app_id'], title: '', body: message}
      r = HTTP.new.post(@config['/goo/keyword/url'], {body: body.to_json}).parsed_response
      r['keywords'].each do |word|
        word.each{|k, v| words.push(k)}
      end
      return words.uniq
    end
  end
end
