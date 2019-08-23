require 'sanitize'

module Makoto
  class RespondWorker
    include Sidekiq::Worker

    def initialize
      @logger = Logger.new
      @config = Config.instance
      @mastodon = Mastodon.new(@config['/mastodon/url'])
      @mastodon.token = @config['/mastodon/token']
    end

    def perform(params)
      template = Template.new('toot')
      template[:account] = params['account']
      template[:message] = create_body(params)
      @mastodon.toot(status: template.to_s, visibility: params['visibility'])
    end

    def create_body(params)
      words = create_word_list(params)
      return words.to_json
    rescue => e
      return e.message
    end

    def create_word_list(params)
      body = {app_id: @config['/goo/app_id'], sentence: Sanitize.clean(params['content'])}
      r = HTTP.new.post(@config['/goo/morph/url'], {body: body.to_json}).parsed_response
      words = TagContainer.scan(Sanitize.clean(params['content']))
      r['word_list'].each do |clause|
        clause.each do |word|
          next unless word[1] == '名詞'
          words.push(word.first)
        end
      end
      words.uniq!
      return words
    rescue => e
      @logger.error(e)
      return []
    end
  end
end
