module Makoto
  class Track < Sequel::Model(:track)
    alias makoto? makoto

    def self.pickup(params = {})
      tracks = Track.dataset
      tracks = tracks.where(makoto: true) if params[:makoto]
      tracks = tracks.where(Sequel.like(:title, "%#{params[:title]}%")) if params[:title].present?
      return tracks.all.sample(random: Random.create)
    end

    def self.refresh
      Postgres.instance.connection.transaction do
        Track.dataset.destroy
        fetch.each do |entry|
          entry['title'] = entry['title'].nfkc
          entry['makoto'] = (entry['makoto'] == 1)
          entry.delete('intro') unless entry['intro'].present?
          Track.create(entry)
        rescue => e
          Logger.new.error(Ginseng::Error.create(e).to_h.merge(entry: entry))
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
      return Ginseng::URI.parse(Config.instance['/track/url'])
    end
  end
end
