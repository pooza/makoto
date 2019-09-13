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
      params[:priority] ||= @config['/quote/priority/min']
      params[:form] ||= ['剣崎真琴']
      params[:keyword] ||= ''
      quotes = clone.keep_if{|v| keep?(v, params)}
      return quotes if params[:detail].present?
      return quotes.map{|v| v['quote']}.uniq
    end

    def keep?(entry, params = {})
      return false if entry['exclude'].present?
      return false if (params[:emotion] == :bad) && (entry['emotion'] != 'bad')
      return false if params[:emotion].nil? && (entry['emotion'] == 'bad')
      return false if entry['priority'] < params[:priority]
      return false unless params[:form].include?(entry['form'])
      return true if entry['quote'].include?(params[:keyword])
      return true if entry['remark'].include?(params[:keyword])
      return false
    end

    def delete
      File.unlink(path) if exist?
    end

    def fetch
      return @http.get(@config['/quote/url']).parsed_response
    end
  end
end
