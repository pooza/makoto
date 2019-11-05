module Makoto
  class QuoteLib < Lib
    def pickup(params = {})
      return quotes(params).sample(random: Random.new(Time.now.to_i))
    end

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
      return false if params[:respond] && entry['exclude_respond'].present?
      return false if (params[:emotion] == :bad) && (entry['emotion'] != 'bad')
      return false if params[:emotion].nil? && (entry['emotion'] == 'bad')
      return false if entry['priority'] < params[:priority]
      return false unless params[:form].include?(entry['form'])
      return keyword_include?(entry, params[:keyword])
    end

    private

    def keyword_include?(entry, keyword)
      pattern = create_pattern(keyword)
      return true if entry['quote'].match(pattern)
      return true if entry['remark'].match(pattern)
      return false
    end
  end
end
