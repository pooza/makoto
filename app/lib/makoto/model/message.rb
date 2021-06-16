module Makoto
  class Message < Sequel::Model(:message)
    include Package

    alias body message

    def self.pickup(params = {})
      messages = Message.dataset
      messages = messages.where(feature: params[:feature]) if params[:feature]
      messages = messages.where(type: params[:type]) if params[:type]
      messages = messages.all
      if params[:season]
        messages.select! do |v|
          v.data.nil? || JSON.parse(v.data)['season'].member?(Time.now.month)
        end
      end
      return messages.sample(random: Random.create)
    end

    def self.refresh
      Postgres.instance.connection.transaction do
        Message.dataset.destroy
        fetch.each do |values|
          Message.create(create_entry(values))
        rescue => e
          logger.error(error: e, entry: values)
        end
      end
    end

    def self.create_entry(values)
      entry = {
        type: values['type'],
        feature: values['feature'],
        message: values['message'],
      }
      [:month, :day, :data].each do |k|
        entry[k] = values[k.to_s] if values[k.to_s].present?
      end
      return entry
    end

    def self.fetch
      return HTTP.new.get(uri).parsed_response
    rescue => e
      logger.error(error: e)
      return []
    end

    def self.uri
      return Ginseng::URI.parse(Config.instance['/message/url'])
    end
  end
end
