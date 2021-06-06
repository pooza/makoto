module Makoto
  class Quote < Sequel::Model(:quote)
    include Package
    many_to_one :series
    many_to_one :form

    def self.pickup(params = {})
      config = Config.instance
      quotes = Quote.dataset.where(
        exclude: false,
        form_id: Form.ids(params[:form]),
      )
      quotes = quotes.where {(params[:priority] || config['/quote/priority/min']) <= priority}
      quotes = quotes.where(exclude_respond: false) if params[:respond]
      quotes = quotes.where(emotion: params[:emotion].to_s) if params[:emotion]
      if keyword = params[:keyword]
        quotes = quotes.where(
          Sequel.like(:body, "%#{keyword}%") | Sequel.like(:remark, "%#{keyword}%"),
        )
      end
      return quotes.all.sample(random: Random.create)
    end

    def self.refresh
      Postgres.instance.connection.transaction do
        Quote.dataset.destroy
        fetch.each do |values|
          Quote.create(create_entry(values))
        rescue => e
          Logger.new.error(Ginseng::Error.create(e).to_h.merge(entry: values))
        end
      end
    end

    def self.create_entry(values)
      entry = {
        series_id: Series.get(values['series']).id,
        form_id: Form.get(values['form']).id,
        body: values['quote'],
        exclude: values['exclude'].present?,
        exclude_respond: values['exclude_respond'].present?,
        priority: values['priority'],
      }
      [:emotion, :episode, :remark].each do |k|
        entry[k] = values[k.to_s] if values[k.to_s].present?
      end
      return entry
    end

    def self.fetch
      return HTTP.new.get(uri).parsed_response
    rescue => e
      Logger.new.error(e)
      return []
    end

    def self.uri
      return Ginseng::URI.parse(Config.instance['/quote/url'])
    end
  end
end
