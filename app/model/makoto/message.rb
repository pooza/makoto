module Makoto
  class Message < Sequel::Model(:message)
    def self.pickup(params = {})
      messages = Message.dataset
      messages = messages.where(feature: params[:feature]) if params[:feature]
      messages = messages.where(message: params[:message]) if params[:message]
      return messages.all.sample(random: Random.create)
    end

    def self.refresh
      Postgres.instance.connection.transaction do
        Message.dataset.destroy
        fetch.each do |values|
          Message.create(create_entry(values))
        rescue => e
          Logger.new.error(Ginseng::Error.create(e).to_h.merge(entry: values))
        end
      end
    end

    def self.create_entry(values)
      return {
        type: values['type'],
        feature: values['feature'],
        message: values['message'],
      }
    end

    def self.fetch
      return HTTP.new.get(uri).parsed_response
    rescue => e
      Logger.new.error(e)
      return []
    end

    def self.uri
      return Ginseng::URI.parse(Config.instance['/message/url'])
    end
  end
end
