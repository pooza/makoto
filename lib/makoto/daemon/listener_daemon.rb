module Makoto
  class ListenerDaemon < Ginseng::Daemon
    include Package

    def cmd
      return File.join(Environment.dir, 'bin/listener_worker.rb')
    end

    def child_pid
      return `pgrep -f #{ListenerDaemon.worker_path}`.to_i
    end

    def motd
      return [
        Package.full_name,
        self.class.to_s,
      ].join("\n")
    end

    def self.worker_path
      return File.join(Environment.dir, 'listener_worker.rb')
    end
  end
end
