module Makoto
  class Keyword < Sequel::Model(:keyword)
    include Package

    def self.refresh
      Postgres.instance.connection.transaction do
        Keyword.dataset.destroy
        fetch.each do |values|
          Keyword.create(create_entry(values))
        rescue => e
          logger.error(error: e, entry: values)
        end
      end
    end

    def self.create_entry(values)
      return {
        type: values['type'],
        word: values['word'],
      }
    end

    def self.fetch
      return HTTP.new.get(uri).parsed_response
    rescue => e
      logger.error(error: e)
      return []
    end

    def self.uri
      return Ginseng::URI.parse(Config.instance['/keyword/url'])
    end
  end
end
