module Makoto
  class ListenerDaemon < Ginseng::Daemon
    include Package

    def command
      return Ginseng::CommandLine.new([File.join(Environment.dir, 'bin/listener_worker.rb')])
    end

    def motd
      return [
        Package.full_name,
        self.class.to_s,
        "Streaming API URL: #{service.create_streaming_uri}",
      ].join("\n")
    end

    def service
      @service ||= Mastodon.new(@config['/mastodon/url'], @config['/mastodon/token'])
      return @service
    end
  end
end
