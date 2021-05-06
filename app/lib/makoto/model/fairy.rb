module Makoto
  class Fairy < Sequel::Model(:fairy)
    def self.suffixes
      return Fairy.all.filter_map(&:suffix)
    end

    def self.refresh
      Postgres.instance.connection.transaction do
        Fairy.dataset.destroy
        fetch.each do |values|
          Fairy.create(create_entry(values))
        rescue => e
          Logger.new.error(Ginseng::Error.create(e).to_h.merge(entry: values))
        end
      end
    end

    def self.create_entry(values)
      entry = {
        name: values['name'],
      }
      [:human_name, :suffix].each do |k|
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
      return Ginseng::URI.parse(Config.instance['/fairy/url'])
    end
  end
end
