require 'natto'
require 'unicode'

module Makoto
  class MarkovInterestedResponder < InterestedResponder
    def initialize
      super
      @table = {}
    end

    # 使用する際、このメソッドを削除
    def executable?
      return false
    end

    def exec
      data = ['BEGIN', 'BEGIN']
      quotes.all.shuffle.each do |quote|
        Natto::MeCab.new.parse(quote.body) do |word|
          data.push(word.surface)
        end
      end
      data.push('END')
      data.each_cons(3).each do |v|
        suffix = v.pop
        prefix = v
        @table[prefix] ||= []
        @table[prefix].push(suffix)
      end
      return markov
    end

    def quotes
      quotes = Quote.dataset.where(
        form_id: @config['/quote/all_forms'].map {|v| Form.first(name: v).id},
      )
      quotes = quotes.where {2 <= priority}
      quotes = quotes.where(
        Sequel.like(:body, "%#{@keyword}%") | Sequel.like(:remark, "%#{@keyword}%"),
      )
      return quotes
    end

    def markov
      random = Random.new
      prefix = ['BEGIN', 'BEGIN']
      body = ''
      loop do
        prefix = [prefix[1], @table[prefix][random.rand(0..(@table[prefix].length - 1))]]
        body += prefix.first unless prefix.first == 'BEGIN'
        if @table[prefix].last == 'END'
          body += prefix[1]
          break
        end
      end
      return body
    end
  end
end
