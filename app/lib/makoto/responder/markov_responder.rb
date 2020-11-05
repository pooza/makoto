require 'natto'

module Makoto
  class MarkovResponder < Responder
    def executable?
      return rand(0..99) < 20
    end

    def exec
      @table = nil
      return markov
    end

    def quotes
      quotes = Quote.dataset.where(
        exclude: false,
        exclude_respond: false,
      )
      quotes = quotes.where {3 <= priority}
      return quotes
    end

    def mecab
      @mecab ||= Natto::MeCab.new
      return @mecab
    end

    def table
      unless @table
        @table = {}
        data = ['START', 'START']
        quotes.all.shuffle.each do |quote|
          mecab.parse(quote.body) do |word|
            data.push(word.surface)
          end
          data.push('END')
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
