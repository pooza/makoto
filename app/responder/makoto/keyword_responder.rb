require 'natto'
require 'unicode'

module Makoto
  class KeywordResponder < Responder
    def initialize
      super
      @paragraphs = []
    end

    def executable?
      templates = {}
      words = analyze(@params['content']).shuffle
      [rand(2..@config['/respond/paragraph/max']), words.count].min.times do
        word = words.pop
        templates[word[:feature]] ||= @config["/respond/templates/#{word[:feature]}"].shuffle
        template = templates[word[:feature]].pop
        @paragraphs.push(template % [word[:surface]])
        break if template.match(/[！？!?]$/)
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

    def analyze(message)
      words = []
      Natto::MeCab.new.parse(message) do |word|
        surface = Unicode.nfkc(word.surface)
        features = word.feature.split(',')
        next unless features.include?('名詞')
        next if @config['/word/ignore'].include?(surface)
        next if features.join =~ /(サ変接続|接尾|非自立|代名詞)/
        feature = '一般'
        ['人名', '地域'].each do |v|
          feature = v if features.include?(v)
        end
        words.push(surface: surface, feature: feature)
      end
      return words.uniq
    end
  end
end
