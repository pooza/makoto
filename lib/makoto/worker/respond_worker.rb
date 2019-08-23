require 'sanitize'
require 'unicode'

module Makoto
  class RespondWorker
    include Sidekiq::Worker

    def initialize
      @logger = Logger.new
      @config = Config.instance
      @mastodon = Mastodon.new(@config['/mastodon/url'])
      @mastodon.token = @config['/mastodon/token']
      @quote_lib = QuoteLib.new
    end

    def perform(params)
      template = Template.new('toot')
      template[:account] = params['account']
      template[:message] = create_body(params)
      @mastodon.toot(
        status: template.to_s,
        visibility: params['visibility'],
        in_reply_to_id: params['toot_id'],
      )
    end

    def create_body(params)
      words = fetch_words(params)
      return quotes.sample unless words.present?
      return words.to_json
    rescue
      return quotes.sample
    end

    def quotes
      return @quote_lib.quotes
    end

    def fetch_words(params)
      text = Sanitize.clean(params['content'])
      text = Unicode.nfkc(text)
      words = TagContainer.scan(text)
      words.concat(analyze_morph(text)) unless 2 <= words.count
      words.uniq!
      @config['/word/ignore'].map{|v| words.delete(v)}
      return words
    rescue => e
      @logger.error(e)
      return []
    end

    def analyze_morph(text)
      body = {app_id: @config['/goo/app_id'], sentence: text}
      words = []
      r = HTTP.new.post(@config['/goo/morph/url'], {body: body.to_json}).parsed_response
      r['word_list'].each do |clause|
        clause.each do |word|
          next unless word[1] == '名詞'
          words.push(word.first)
        end
      end
      return words.uniq
    end
  end
end
