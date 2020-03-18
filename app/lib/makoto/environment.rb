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
        sidekiq: sidekiq_stats,
        status: 200,
      }
      [:sidekiq].each do |k|
        values[:status] = 503 unless values.dig(k, :status) == 'OK'
      end
      return values
    end

    def self.sidekiq_stats
      stats = Sidekiq::Stats.new
      pids = Sidekiq::ProcessSet.new.map {|p| p['pid']}
      values = {
        queues: stats.queues['default'],
        retry: stats.retry_size,
        status: pids.present? ? 'OK' : 'NG',
      }
      pids.each do |pid|
        Process.kill(0, pid)
      rescue
        raise "PID '#{pid}' was dead"
      end
      return values
    rescue => e
      return {error: e.message, status: 'NG'}
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
