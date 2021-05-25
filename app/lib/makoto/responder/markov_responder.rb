require 'natto'

module Makoto
  class MarkovResponder < Responder
    def executable?
      return rand < @config['/respond/markov/frequency']
    end

    def exec
      paragraphs.concat(markov.gsub(/[！？!?。]/, '\\0|').split('|').compact.uniq)
    end

    def favorability
      return rand(0..1)
    end

    def quotes
      return Quote.dataset
          .where(exclude: false, exclude_respond: false, emotion: nil)
          .where {3 <= priority}
    end

    def messages
      return Message.dataset.where(type: 'morning')
    end

    def mecab
      @mecab ||= Natto::MeCab.new
      return @mecab
    end

    def table
      unless @table
        @table = {}
        data = ['START', 'START']
        [quotes, messages].each do |collection|
          collection.all.shuffle.each do |item|
            mecab.parse(item.body) do |word|
              data.push(word.surface)
            end
            data.push('END')
          end
        end
        data.each_cons(3).each do |v|
          suffix = v.pop
          prefix = v
          @table[prefix] ||= []
          @table[prefix].push(suffix)
        end
      end
      return @table
    end

    def markov
      prefix = ['START', 'START']
      body = []
      loop do
        prefix = [prefix.last, table[prefix].sample(random: Random.create)]
        next if prefix.first == 'START'
        body.push(prefix.first)
        if table[prefix].last == 'END'
          body.push(prefix.last)
          break
        end
      end
      return body.join
    end
  end
end
