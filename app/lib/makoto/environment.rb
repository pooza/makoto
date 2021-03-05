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
        version: Package.version,
        listener: ListenerDaemon.health,
        postgres: Postgres.health,
        sidekiq: SidekiqDaemon.health,
        status: 200,
      }
      if [:listener, :postgres, :sidekiq].any? {|v| values.dig(v, :status) != 'OK'}
        values[:status] = 503
      end
      return values
    end

    def self.auth(username, password)
      config = Config.instance
      return false unless username == config['/sidekiq/auth/user']
      return true if password.crypt(Environment.hostname) == config['/sidekiq/auth/password']
      return true if password == config['/sidekiq/auth/password']
      return false
    end
  end
end
