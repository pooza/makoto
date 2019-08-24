module Makoto
  class TrackLib < Array
    def initialize
      super
      @logger = Logger.new
      @config = Config.instance
      @http = HTTP.new
      load
    end

    def exist?
      return File.exist?(path)
    end

    def path
      return File.join(Environment.dir, 'tmp/cache/track_lib')
    end

    def load
      return unless exist?
      clear
      concat(Marshal.load(File.read(path)))
    end

    def refresh
      File.write(path, Marshal.dump(fetch))
      load
    rescue => e
      @logger.error(e)
    end

    alias create refresh

    def tracks
      return map{|v| v['url']}.uniq
    end

    def delete
      File.unlink(path) if exist?
    end

    def fetch
      return @http.get(@config['/tracks/url']).parsed_response
    end
  end
end
