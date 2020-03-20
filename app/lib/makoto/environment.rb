module Makoto
  class Environment < Ginseng::Environment
    def self.name
      return File.basename(dir)
    end

    def self.dir
      return Makoto.dir
    end

    def self.health
      values = {
        version: Package.version,
        listener: ListenerDaemon.health,
        postgres: Postgres.health,
        sidekiq: SidekiqDaemon.health,
        status: 200,
      }
      [:listener, :postgres, :sidekiq].each do |k|
        next if values.dig(k, :status) == 'OK'
        values[:status] = 503
        break
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
