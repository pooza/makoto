module Makoto
  class ListenerDaemon < Ginseng::Daemon
    include Package

    def command
      return Ginseng::CommandLine.new([
        File.join(Environment.dir, 'bin/listener_worker.rb'),
      ])
    end

    def motd
      return [
        "#{self.class} #{Package.version}",
      ].join("\n")
    end

    def service
      @service ||= Mastodon.new(config['/mastodon/url'], config['/mastodon/token'])
      return @service
    end

    def self.health
      pid = File.read(File.join(Environment.dir, 'tmp/pids/ListenerDaemon.pid')).to_i
      raise "PID '#{pid}' was dead" unless Process.alive?(pid)
      return {status: 'OK'}
    rescue => e
      return {error: e.message, status: 'NG'}
    end
  end
end
