module Makoto
  class RespondWorker
    include Sidekiq::Worker

    def initialize
      @logger = Logger.new
      @config = Config.instance
      @mastodon = Mastodon.new(@config['/mastodon/url'], @config['/mastodon/token'])
      @quote_lib = QuoteLib.new
    end

    def perform(params)
      template = Template.new('toot')
      template[:account] = params['account']
      template[:message] = create_message(params)
      @mastodon.toot(
        status: template.to_s,
        visibility: params['visibility'],
        in_reply_to_id: params['toot_id'],
      )
    end

    def create_message(params)
      return @quote_lib.quotes(emotion: :bad).sample if ng?(params)
      words = create_word_list(params)
      templates = create_template_list
      body = []
      [rand(@config['/reply/paragraphs/max']), words.count, templates.count].min.times do
        body.push(templates.pop % [words.pop])
        break if body.last.match(/[！？!?]$/)
      end
      return @quote_lib.quotes.sample unless body.present?
      return body.join
    rescue => e
      @logger.error(e)
      return @quote_lib.quotes.sample
    end

    def ng?(params)
      QuoteLib.ng_words.each do |word|
        return true if params['content'].include?(word)
      end
      return false
    end

    def create_word_list(params)
      words = TagContainer.scan(params['content'])
      words -= @config['/tag/ignore']
      words.concat(analyze(params['content'])) unless words.present?
      words -= @config['/tag/ignore']
      words -= @config['/word/ignore']
      return words.uniq.shuffle
    rescue => e
      @logger.error(e)
      return []
    end

    def create_template_list
      return @config['/reply/templates'].shuffle
    end

    def analyze(text)
      body = {app_id: @config['/goo/app_id'], sentence: text}
      words = []
      r = HTTP.new.post(@config['/goo/morph/url'], {body: body.to_json}).parsed_response
      r['word_list'].each do |clause|
        clause.each do |word|
          next if word.first.length < @config['/word/length/min']
          next unless word[1] == '名詞'
          words.push(word.first)
        end
      end
      return words.uniq
    end
  end
end
