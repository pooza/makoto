module Makoto
  class ListenerDaemon < Ginseng::Daemon
    include Package

    def cmd
      return File.join(Environment.dir, 'bin/listener_worker.rb')
    end

    def motd
      return [
        Package.full_name,
        self.class.to_s,
      ].join("\n")
    end
  end
end
