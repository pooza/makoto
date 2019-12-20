module Makoto
  class Quote < Sequel::Model(:quote)
    def self.pickup(params = {})
      config = Config.instance
      quotes = Quote.dataset.where(
        exclude: false,
        form_id: (params[:form] || config['/quote/default_forms']).map {|v| Form.first(name: v).id},
      )
      quotes = quotes.where {(params[:priority] || config['/quote/priority/min']) <= priority}
      quotes = quotes.where(exclude_respond: false) if params[:respond]
      quotes = quotes.where(emotion: params[:emotion].to_s) if params[:emotion]
      if params[:keyword]
        keyword = params[:keyword]
        quotes = quotes.where(
          Sequel.like(:body, "%#{keyword}%") | Sequel.like(:remark, "%#{keyword}%"),
        )
      end
      return quotes.all.sample(random: Random.create)
    end

    def self.refresh
      Postgres.instance.connection.transaction do
        Quote.dataset.destroy
        fetch.each do |entry|
          values = {
            series_id: Series.get(entry['series']).id,
            form_id: Form.get(entry['form']).id,
            body: entry['quote'],
            exclude: entry['exclude'].present?,
            exclude_respond: entry['exclude_respond'].present?,
            priority: entry['priority'],
          }
          [:emotion, :episode, :remark].each do |k|
            values[k] = entry[k.to_s] if entry[k.to_s].present?
          end
          Quote.create(values)
        rescue => e
          Logger.new.error(e)
        end
      end
    end

    def self.fetch
      return HTTP.new.get(uri).parsed_response
    rescue => e
      Logger.new.error(e)
      return []
    end

    def self.uri
      return URI.parse(Config.instance['/quote/url'])
    end
  end
end
