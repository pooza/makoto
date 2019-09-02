module Makoto
  class QuoteLib < Array
    def initialize
      super
      @logger = Logger.new
      @config = Config.instance
      @http = HTTP.new
      load
    end

    def exist?
      return File.exist?(path)
    end

    def path
      return File.join(Environment.dir, 'tmp/cache/quote_lib')
    end

    def load
      return unless exist?
      clear
      concat(Marshal.load(File.read(path)))
    end

    def refresh
      File.write(path, Marshal.dump(fetch))
      load
    rescue => e
      @logger.error(e)
    end

    alias create refresh

    def quotes(params = {})
      params[:priority] ||= @config['/quotes/priority/min']
      params[:form] ||= ['剣崎真琴']
      quotes = clone
      if params[:emotion] == :bad
        quotes = quotes.keep_if{|v| v['emotion'] == 'bad'}
      else
        quotes = quotes.delete_if{|v| v['emotion'] == 'bad'}
      end
      quotes = quotes.keep_if{|v| params[:priority] <= v['priority']}
      quotes = quotes.delete_if{|v| params[:exclude].present?}
      quotes = quotes.keep_if{|v| params[:form].include?(v['form'])}
      return quotes.map{|v| v['quote']}.uniq
    end

    def delete
      File.unlink(path) if exist?
    end

    def fetch
      return @http.get(@config['/quotes/url']).parsed_response
    end

    def self.ng_words
      return Config.instance['/word/ng']
    end
  end
end
