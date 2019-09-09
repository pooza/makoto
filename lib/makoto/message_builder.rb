require 'sanitize'
require 'unicode'

module Makoto
  class MessageBuilder
    def initialize(params)
      @config = Config.instance
      @params = params
      @params['content'] = MessageBuilder.sanitize(@params['content'])
      @logger = Logger.new
      @quote_lib = QuoteLib.new
      @paragraphs = []
    end

    def build
      return @quote_lib.quotes(emotion: :bad).sample if ng?
      words = analyze(@params['content']).shuffle
      templates = @config['/reply/templates'].shuffle
      [rand(1..@config['/reply/paragraphs/max']), words.count, templates.count].min.times do
        @paragraphs.push(templates.pop % [words.pop])
        break if last?
      end
      return @quote_lib.quotes.sample unless @paragraphs.present?
      return @paragraphs.join
    rescue => e
      @logger.error(e)
      return @quote_lib.quotes.sample
    end

    def last?
      return @paragraphs.last.match(/[！？!?]$/)
    end

    def ng?
      @config['/word/ng'].each do |word|
        return true if @params['content'].include?(word)
      end
      return false
    end

    def analyze(message)
      words = @config['/reply/topics'].clone.keep_if{|v| message.include?(v)}
      words.concat(TagContainer.scan(message))
      words -= @config['/tag/ignore']
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

    def self.sanitize(message)
      message = Sanitize.clean(message)
      message = Unicode.nfkc(message)
      return message
    end

    def self.respondable?(payload)
      config = Config.instance
      return false if config['/reply/ignore_accounts'].include?(payload['account']['acct'])
      content = sanitize(payload['content'])
      return false if content.match(Regexp.new("@#{config['/reply/me']}(\\s|$)"))
      config['/reply/topics'].each do |topic|
        return true if content.include?(topic)
      end
      return false
    end
  end
end
