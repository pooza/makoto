module Makoto
  class Environment < Ginseng::Environment
    def self.name
      return File.basename(dir)
    end

    def self.dir
      return Makoto.dir
    end

    def self.type
      return Config.instance['/environment'] || 'development'
    end

    def self.development?
      return type == 'development'
    end

    def self.production?
      return type == 'production'
    end

    def self.health
      values = {
        listener: ListenerDaemon.health,
        postgres: Postgres.health,
        sidekiq: SidekiqDaemon.health,
      }
      values[:status] = 503 if values.values.any? {|v| v[:status] != 'OK'}
      values[:status] ||= 200
      return values
    end
  end
end
